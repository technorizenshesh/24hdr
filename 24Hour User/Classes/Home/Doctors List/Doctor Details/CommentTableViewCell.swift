//
//  CommentTableViewCell.swift
//  24Hour User
//
//  Created by mac on 12/07/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    @IBOutlet weak var lbl_Description: UILabel!
    
    @IBOutlet weak var lbl_daysAgo: UILabel!
    @IBOutlet weak var lbl_username: UILabel!
    @IBOutlet weak var img_Commentuser: ImageView!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
