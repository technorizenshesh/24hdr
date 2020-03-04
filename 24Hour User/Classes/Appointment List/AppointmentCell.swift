//
//  AppointmentCell.swift
//  24Hour User
//
//  Created by mac on 30/05/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class AppointmentCell: UITableViewCell {
    
    @IBOutlet weak var btn_Delete: UIButton!
    @IBOutlet weak var imgView: ImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPost: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var btn_Reschedule: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
