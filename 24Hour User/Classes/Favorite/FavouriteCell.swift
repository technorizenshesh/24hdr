//
//  FavouriteCell.swift
//  24Hour User
//
//  Created by mac on 20/05/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class FavouriteCell: UITableViewCell {

    @IBOutlet weak var imgView: ImageView!
    @IBOutlet weak var lbl_Immedate: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblSesignation: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
