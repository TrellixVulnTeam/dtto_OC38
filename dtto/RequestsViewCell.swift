//
//  RequestsViewCell.swift
//  dtto
//
//  Created by Jitae Kim on 12/22/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class RequestsViewCell: UITableViewCell {

    weak var requestsDelegate: RequestsDelegate?
    
    @IBOutlet weak var profile: RoundImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var displayName: UILabel!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var declineButton: UIButton!
    
    @IBAction func acceptRequest(_ sender: UIButton!) {
        sender.bounceAnimate()
        requestsDelegate?.handleRequest(row: sender.tag, action: .accept)
    }
    
    @IBAction func declineRequest(_ sender: UIButton!) {
        sender.bounceAnimate()
        requestsDelegate?.handleRequest(row: sender.tag, action: .decline)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
