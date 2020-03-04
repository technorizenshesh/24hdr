//
//  ConversationsCell.swift
//  Batto
//
//  Created by mac on 27/03/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class ConversationsCell: UITableViewCell {

    @IBOutlet weak var imgUser: ImageView!
    @IBOutlet weak var lblMsg: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
