//
//  Hotel.swift
//  shudenkun
//
//  Created by 前原 秀徳 on 2015/06/17.
//  Copyright (c) 2015年 m18dev. All rights reserved.
//

import Foundation

class Hotel {
    var name: String
    var roomImageUrl: String
    var telephoneNo: String
    
    init(name: String, roomImageUrl: String, telephoneNo: String) {
        self.name = name
        self.roomImageUrl = roomImageUrl
        self.telephoneNo = telephoneNo
    }
}