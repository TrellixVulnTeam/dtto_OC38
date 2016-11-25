//
//  ChatViewController.swift
//  Bounce
//
//  Created by Jitae Kim on 11/21/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import Firebase


class ChatListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var senderDisplayName: String? 
    var newChannelTextField: UITextField?

    private var channelRefHandle: FIRDatabaseHandle?
    private var channels = [Channel]()
    
    private lazy var channelRef: FIRDatabaseReference = FIRDatabase.database().reference().child("channel")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func observeChannels() {
        // We can use the observe method to listen for new
        // channels being written to the Firebase DB
        channelRefHandle = channelRef.observe(.childAdded, with: { (snapshot) -> Void in
            let channelData = snapshot.value as! Dictionary<String, AnyObject>
            let id = snapshot.key
            if let name = channelData["name"] as! String!, name.characters.count > 0 {
                self.channels.append(Channel(id: id, name: name))
                self.tableView.reloadData()
            } else {
                print("Error! Could not decode channel data")
            }
        })
    }

    deinit {
        if let refHandle = channelRefHandle {
            channelRef.removeObserver(withHandle: refHandle)
        }
    }
    
    /// MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let channel = sender as? Channel {
            let chatVc = segue.destination as! ChatViewController
            
            chatVc.senderDisplayName = senderDisplayName
            chatVc.channel = channel
            chatVc.channelRef = channelRef.child(channel.id)
        }
    }

}
