//
//  MenuCell.swift
//  BigPaya
//
//  Created by mac on 02/05/18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {

    @IBOutlet weak var imgTitle: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
