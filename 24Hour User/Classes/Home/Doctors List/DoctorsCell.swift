//
//  DoctorsCell.swift
//  24Hour User
//
//  Created by mac on 14/05/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class DoctorsCell: UITableViewCell {

    @IBOutlet weak var lbl_Speicality: UILabel!
    @IBOutlet weak var imgView: ImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPost: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
