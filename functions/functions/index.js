const functions = require('firebase-functions');
const admin = require('firebase-admin');
const nodemailer = require('nodemailer');
const logging = require('@google-cloud/logging')();
const stripe = require('stripe')(functions.config().stripe.token),
      currency = functions.config().stripe.currency || 'USD';

admin.initializeApp(functions.config().firebase);

const gmailEmail = encodeURIComponent(functions.config().gmail.email);
const gmailPassword = encodeURIComponent(functions.config().gmail.password);
const mailTransport = nodemailer.createTransport(`smtps://${gmailEmail}:${gmailPassword}@smtp.gmail.com`);
const APP_NAME = "dtto";

// EMAIL NOTIFICATIONS

exports.createUser = functions.auth.user().onCreate(event => {

  const user = event.data; // The Firebase user.
  const email = user.email; // The email of the user.
  const name = user.displayName; // The user's real name. Set automatically with login providers.
  
  // Make sure emails are unique

  const escapedEmail = email.replace(/\./g, ',');
  console.log(escapedEmail);
  admin.database().ref(`/userEmails/${escapedEmail}`).set(true);

  // Set up initial user data.
  const userID = user.uid;
  console.log(userID);

  // Private user data. User sees detailed stats when viewing their own profile.
  admin.database().ref(`/users/${userID}`).set({

    helpsGivenCount: 0,
    resolvedChatsCount: 0,
    totalChatRequestsReceivedCount: 0,
    relatesGivenCount: 0,
    requestsCount: 0,
    shareCount: 0,
    totalChatCount: 0

  });

  // Public Profile data. Readable by everyone.
  admin.database().ref(`/profiles/${userID}`).set({

    name: name,
    email: email,
    helpfulCount: 0,
    relatesReceivedCount: 0,
    postCount: 0,
    profileViewCount: 0,
    joined: admin.database.ServerValue.TIMESTAMP

  });

  // sendWelcomeEmail(email, name);
  
});

function sendWelcomeEmail(email, displayName) {
  const mailOptions = {
    from: '"dtto" <noreply@firebase.com>',
    to: email
  };

  // The user unsubscribed to the newsletter.
  mailOptions.subject = `Welcome to ${APP_NAME}!`;
  mailOptions.text = `Hey ${displayName}!, Welcome to ${APP_NAME}. I hope you will enjoy our service.`;
  return mailTransport.sendMail(mailOptions).then(() => {
    console.log('New welcome email sent to:', email);
  });
}

exports.deleteUser = functions.auth.user().onDelete(event => {

  const user = event.data;
  const userID = user.uid;
  const email = user.email;
  const escapedEmail = email.replace(/\./g, ',');
  const name = user.displayName;  // TODO: name vs username.

  admin.database().ref(`/users/${userID}`).remove();
  admin.database().ref(`/profiles/${userID}`).remove();
  admin.database().ref(`/userEmails/${escapedEmail}`).remove();

  // TODO: Handle posts + comments

  sendGoodbyEmail(email, name);

});

// Sends a goodbye email to the given user.
function sendGoodbyEmail(email, displayName) {
  const mailOptions = {
    from: '"dtto" <noreply@firebase.com>',
    to: email
  };

  // The user unsubscribed to the newsletter.
  mailOptions.subject = `Bye!`;
  mailOptions.text = `Hey ${displayName}!, We confirm that we have deleted your ${APP_NAME} account.`;
  return mailTransport.sendMail(mailOptions).then(() => {
    console.log('Account deletion confirmation email sent to:', email);
  });
}


// PUSH NOTIFICATIONS

// Sends a notification when a user requests chat.
exports.sendChatRequestNotification = functions.database.ref('/requests/{posterID}/{requestID}').onWrite(event => {

  // Only send when the request is sent, not deleted.
  if (!event.data.val()) {
    console.log('chat request was deleted.')
    return
  }

  const snapshot = event.data;
  const posterID = event.params.posterID;
  const senderID = snapshot.val().senderID;

// only send notification if this is the first request and poster did not ignore this user.

  if (snapshot.val().pending) {

      const payload = {
        notification: {
          title: `${snapshot.val().senderName} sent you a chat request.`,
          body: 'Start chatting.',
        },
        data: {
          "type" : "request"
        }
      };
      sendNotification(posterID, senderID, payload);
    }

});

// sends a notification to user requested this chat.
exports.sendChatAcceptedNotification = functions.database.ref('/chats/{chatID}/posterID').onWrite(event => {

  // Only send when the chat is created, NOT deleted
  if (!event.data.val()) {
    return
  }

  const chatID = event.params.chatID;
  const posterID = event.data.val();

  admin.database().ref(`/chats/${chatID}`).once('value').then(snapshot => {

    // receiver is the helper, because the helper is waiting for the chat to start.
    const receiverID = snapshot.val().helperID;

    admin.database().ref(`/users/${posterID}/username`).once('value').then(snapshot => {

      const username = snapshot.val();
      const chatAcceptedPayload = {
        notification: {
          title: `${username} accepted your chat request!`,
          body: `Start chatting now.`      
        },
        data: {
          "type" : "message",
          "chatID" : chatID
        }
      };

      sendNotification(receiverID, posterID, chatAcceptedPayload);

    });

  });

});

// Sends a chat message notification to the partner.
exports.sendChatNotification = functions.database.ref('/chats/{chatID}').onWrite(event => {

  const snapshot = event.data;

  // Only send a notification when the chat has been resolved.
  if (!snapshot.val()) {
    return;
  }

  const senderID = snapshot.val().senderID;
  const posterID = snapshot.val().posterID;
  const helperID = snapshot.val().helperID;
  const chatID = snapshot.key;
  const senderName = snapshot.val().senderName;
  const text = snapshot.val().text;

  var receiverID;

  if (senderID == posterID) {
    receiverID = helperID;
  }
  else {
    receiverID = posterID;
  }

  admin.database().ref(`/users/${receiverID}/chats/${chatID}`).once('value').then(snapshot => {

    // Check if the receiver muted this chat.
    if (!snapshot.val()) {
      return
    }

    // Notification details.
    const payload = {
      notification: {
        title: `${senderName} sent you ${text ? 'a message' : 'an image'}`,
        body: text ? (text.length <= 100 ? text : text.substring(0, 97) + '...') : ''      
      },
      data: {
        "type" : "message",
        "chatID" : chatID
      }
    };
    
    sendNotification(receiverID, senderID, payload);

  });

});

// sends a notification to the poster.
exports.sendRelateNotification = functions.database.ref('/postRelates/{postID}/{relaterID}}').onWrite(event => {

  // only notify if the relate was incremented. TODO: handle when someone relates -> unrelates -> relates
  if (!event.data.val()) {
    return
  }

  const snapshot = event.data;
  const postID = event.params.postID;
  const senderID = snapshot.key;
  const senderName = snapshot.val().username;

  // get the post's posterID
  admin.database().ref(`/posts/${postID}/userID`).once('value').then(snapshot => {

    const receiverID = snapshot.val();
    // Notification details.

    const payload = {
      notification: {
        title: `${senderName} related to you.`,
        body: 'View post.'      
      },
      data: {
        "type" : "relate",
        "postID" : postID
      }
    };
    
    sendNotification(receiverID, senderID, payload);

     // Update the receiver's node in database.
    var notificationsRef = admin.database().ref(`/users/${receiverID}/notifications`);
    var newNotificationRef = notificationsRef.push();
    newNotificationRef.set({

      type: "relate",
      senderID: senderID,
      senderName: senderName,
      postID: postID,
      timestamp: admin.database.ServerValue.TIMESTAMP

    });

    // also update /users/user/relatedPosts with the autoID so that the user can delete the notification when un-relating.
    const autoID = newNotificationRef.key;
    const userRelatedPostsRef = admin.database().ref(`/users/${senderID}/relatedPosts/${postID}`);
    userRelatedPostsRef.set(autoID);

  });
  
});

// send all comment notifications to the poster.
exports.sendCommentNotification = functions.database.ref('/comments/{postID}/{commentID}').onWrite(event => {

  // Exit if someone edited or deleted their comment.
  if (event.data.previous.exists()) {
    console.log('someone edited comment.');
    return;
  }

  const snapshot = event.data;
  const postID = event.params.postID;

  const senderID = snapshot.val().userID;
  const senderName = snapshot.val().username;
  const text = snapshot.val().text;
  const timestamp = snapshot.val().timestamp;

  // get the poster's userID.
  admin.database().ref(`/posts/${postID}/userID`).once('value').then(snapshot => {

    const receiverID = snapshot.val();
    // if the poster commented on own post, don't notify.
    if (receiverID == senderID) {
      console.log('poster commented on own post.');
      return;
    }
    
    // post to /user/notifications
    var notificationsRef = admin.database().ref(`/users/${receiverID}/notifications`);
    var newNotificationRef = notificationsRef.push();
    newNotificationRef.set({

      type: "comment",
      senderID: senderID,
      senderName: senderName,
      postID: postID,
      timestamp: timestamp

    });

    // Notification details.
    const payload = {
      notification: {
        title: `${senderName} commented on your post.`,
        body: text ? (text.length <= 100 ? text : text.substring(0, 97) + '...') : ''      
      },
      data: {
        "type" : "comment",
        "postID" : postID
      }
    };
    
    sendNotification(receiverID, senderID, payload);

  });

});

// sends a notification to the helper
exports.sendResolvedNotification = functions.database.ref('/chats/{chatID}/resolved').onWrite(event => {

  if (event.data.previous.val()) {
    return;
  }
  const chatID = event.params.chatID;
  admin.database().ref(`/chats/${chatID}`).once('value').then(snapshot => {

    // sender is the poster, or the one who initiated the chat (search function)
    const senderID = snapshot.val().posterID;
    const receiverID = snapshot.val().helperID;
    const postID = snapshot.val().postID;

    admin.database().ref(`/users/${senderID}/username`).once('value').then(snapshot => {

      const username = snapshot.val();

      const payload = {
        notification: {
          title: `${username} endorsed you for being helpful.`,
          body: 'Go to chat.'
        },
        data: {
          "type" : "message",
          "chatID" : chatID
        }
      };

      sendNotification(receiverID, senderID, payload);

      // Update the receiver's node in database.
      var notificationsRef = admin.database().ref(`/users/${receiverID}/notifications`);
      var newNotificationRef = notificationsRef.push();
      console.log('updating database...');
      newNotificationRef.set({

        type: "resolve",
        senderID: senderID,
        senderName: username,
        chatID: chatID,
        postID: postID,
        timestamp: admin.database.ServerValue.TIMESTAMP

      });

    });

  });
  
});

function sendNotification(receiverID, senderID, payload) {

  // User should not be able to send notification to self
  if (receiverID == senderID) {
    console.log('User sending notification to self, exit.')
    return
  }

  // Check if the receiver blocked the sender
  return admin.database().ref(`/users/${receiverID}/blockedUsers/${senderID}`).once('value').then(snapshot => {
    if (!snapshot.val()) {
      // Get the list of the receiver's device tokens.
      return admin.database().ref(`/users/${receiverID}/notificationTokens`).once('value').then(allTokens => {
        console.log(allTokens.val());
        if (allTokens.val()) {
          // Listing all tokens.
          const tokens = Object.keys(allTokens.val());
          // Send notifications to all tokens.
          return admin.messaging().sendToDevice(tokens, payload).then(response => {
            // For each message check if there was an error.
            const tokensToRemove = [];
            response.results.forEach((result, index) => {
              const error = result.error;
              if (error) {
                console.error('Failure sending notification to', tokens[index], error);
                // Cleanup the tokens who are not registered anymore.
                if (error.code === 'messaging/invalid-registration-token' ||
                    error.code === 'messaging/registration-token-not-registered') {
                  tokensToRemove.push(allTokens.ref.child(tokens[index]).remove());
                }
              }
            });
            return Promise.all(tokensToRemove);
          });
        }
      });
    }
  });

}


// Counters

// Post relates.

// Keeps track of the length of the 'likes' child list in a separate property.
// exports.postRelatesChange = functions.database.ref('/postRelates/{postID}/{userID}').onWrite(event => {
  
//   const postID = event.params.postID;
//   const relatesCountRef = admin.database().ref(`posts/${postID}/relatesCount`);

//   // Return the promise from countRef.transaction() so our function 
//   // waits for this async event to complete before it exits.
//   return relatesCountRef.transaction(current => {
//     if (event.data.exists() && !event.data.previous.exists()) {
//       return (current || 0) + 1;
//     }
//     else if (!event.data.exists() && event.data.previous.exists()) {
//       return (current || 0) - 1;
//     }
//   }).then(() => {
//     console.log('Counter updated.');
//   });
// });

// // If the number of relates gets deleted, recount the number of relates
// exports.recountRelates = functions.database.ref('/posts/{postid}/relatesCount').onWrite(event => {
//   if (!event.data.exists()) {

//     const collectionRef = functions.database().ref(`/postRelates/${postID}/{userID}`);
    
//     // Return the promise from counterRef.set() so our function 
//     // waits for this async event to complete before it exits.
//     return collectionRef.once('value')
//         .then(messagesData => counterRef.set(messagesData.numChildren()));
//   }
// });