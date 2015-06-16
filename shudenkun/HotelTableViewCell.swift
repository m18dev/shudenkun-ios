//
//  HotelTableViewCell.swift
//  shudenkun
//
//  Created by 前原 秀徳 on 2015/06/17.
//  Copyright (c) 2015年 m18dev. All rights reserved.
//

import UIKit

class HotelTableViewCell: UITableViewCell {

    @IBOutlet weak var hotelNameLabel: UILabel!
    @IBOutlet weak var hotelImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
