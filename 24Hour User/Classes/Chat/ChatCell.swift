//
//  ChatCell.swift
//  24Hour Doctor
//
//  Created by mac on 23/05/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {

    @IBOutlet weak var imgView: ImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLastSeen: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
