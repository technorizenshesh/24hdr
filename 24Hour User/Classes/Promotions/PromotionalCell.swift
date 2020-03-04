//
//  PromotionalCell.swift
//  24Hour User
//
//  Created by mac on 03/06/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class PromotionalCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDetails: UILabel!
    
    @IBOutlet weak var btn_Delete: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
