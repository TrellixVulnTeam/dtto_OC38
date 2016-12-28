//
//  ProfileImage.swift
//  dtto
//
//  Created by Jitae Kim on 12/26/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class ProfileImageCell: UITableViewCell {

    @IBOutlet weak var profileImage: RoundImageView!
    
    @IBOutlet weak var endorse: UILabel!
    @IBOutlet weak var name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
