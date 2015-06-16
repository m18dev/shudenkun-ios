//
//  RakutenApiController.swift
//  shudenkun
//
//  Created by 前原 秀徳 on 2015/06/17.
//  Copyright (c) 2015年 m18dev. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol RakutenAPIControllerProtocol {
    func didReceiveRakutenAPIResults(data: JSON)
}

class RakutenAPIController {
    
    var delegate: RakutenAPIControllerProtocol
    
    init(delegate: RakutenAPIControllerProtocol) {
        self.delegate = delegate
    }
    
    func searchHotels() {
        let longitude: Double! = NSUserDefaults.standardUserDefaults().doubleForKey("CURRENT_LONGITUDE")
        let latitude: Double! = NSUserDefaults.standardUserDefaults().doubleForKey("CURRENT_LATITUDE")
        let nearStation: String! = NSUserDefaults.standardUserDefaults().stringForKey("NEAR_STATION")
        
        NSLog("searching rakuten api...long: \(longitude), lat: \(latitude), nearStation: \(nearStation)")
        
        Alamofire.request(.GET, "https://app.rakuten.co.jp/services/api/Travel/SimpleHotelSearch/20131024", parameters: [
                "applicationId": 1000220328079992423,
                "format": "json",
                "formatVersion": 2,
                "longitude": longitude,
                "latitude": latitude,
                "searchRadius": 1,
                "hits": 5,
                "datumType": 1
            ])
            .responseJSON { (_, _, json, error) in
                if(error != nil) {
                    println("[ERROR] search rakuten api: \(error)")
                } else {
                    let data = JSON(json!)
                    
                    
                    // delegateに結果を返す
                    self.delegate.didReceiveRakutenAPIResults(data) // THIS IS THE NEW LINE!!
                    
                }
            }
    }
}

