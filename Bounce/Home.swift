//
//  Home.swift
//  Bounce
//
//  Created by Jitae Kim on 11/18/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import Koloda
import Firebase

enum ButtonType: Int {
    case undo = 0
    case decline = 1
    case accept = 2
    case save = 3
}

class Home: UIViewController {
    
    @IBOutlet weak var kolodaView: KolodaView!

    @IBOutlet weak var undoButton: CircleButton!
    @IBOutlet weak var declineButton: CircleButton!
    @IBOutlet weak var acceptButton: CircleButton!

    @IBAction func logout(_ sender: Any) {
        try! FIRAuth.auth()!.signOut()

    }
    var people = [Person]()
    var images = [#imageLiteral(resourceName: "profile"), #imageLiteral(resourceName: "roksanaMain"), #imageLiteral(resourceName: "lilicemain")]
    
    @IBAction func pressedButton(_ sender: UIButton) {
        
        sender.bounceAnimate()
        
        switch sender.tag {
            
        case ButtonType.undo.rawValue:
            kolodaView.revertAction()
            print("Pressed undo")
        case ButtonType.decline.rawValue:
            kolodaView.swipe(.left)
            print("Pressed decline")
        case ButtonType.accept.rawValue:
            kolodaView.swipe(.right)
            print("Pressed accept")
        case ButtonType.save.rawValue:
            kolodaView.swipe(.right)
            print("Pressed save")
        default:
            break
        }
        
    }
    
    func layoutButtons() {
        
        undoButton.setBackgroundColor(color: .yellow, forState: .highlighted)
        undoButton.setImage(#imageLiteral(resourceName: "undoNormal"), for: .normal)
        undoButton.setImage(#imageLiteral(resourceName: "undoHighlighted"), for: .highlighted)
        undoButton.tag = 0
        
        declineButton.setBackgroundColor(color: Color.red, forState: .highlighted)
        declineButton.setImage(_: #imageLiteral(resourceName: "declineNormal"), for: .normal)
        declineButton.setImage(_: #imageLiteral(resourceName: "declineHighlighted"), for: .highlighted)
        declineButton.tag = 1
        
        acceptButton.setBackgroundColor(color: Color.lightGreen, forState: .highlighted)
        acceptButton.setImage(_: #imageLiteral(resourceName: "acceptNormal"), for: .normal)
        acceptButton.setImage(_: #imageLiteral(resourceName: "acceptHighlighted"), for: .highlighted)
        acceptButton.tag = 2
        

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"
        people.insert(Person(name: "Jitae", image: #imageLiteral(resourceName: "profile")), at: 0)
        people.insert(Person(name: "Lilice", image: #imageLiteral(resourceName: "lilicemain")), at: 0)
        people.insert(Person(name: "Roksana", image: #imageLiteral(resourceName: "roksanaMain")), at: 0)
        
        layoutButtons()
        kolodaView.delegate = self
        kolodaView.dataSource = self
        
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension Home: KolodaViewDelegate {
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        print("Selected card at index \(index)")
        // push vc
        
    }
}

extension Home: KolodaViewDataSource {
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        
        if people.count == 0 {
            print("empty array")
        }
        
        return people.count
        
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {

        if let card = Bundle.main.loadNibNamed("Card", owner: self, options: nil)?.first as? Card {
            
            card.cardName.text = people[index].getName()
            card.cardImage.image = people[index].getImage()
            card.cardQuestion.text = people[index].getQuestion()
            return card
            
        }
        else {
            return UIView()
        }
        
    }
    
}
