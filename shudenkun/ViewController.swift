//
//  ViewController.swift
//  shudenkun
//
//  Created by 前原 秀徳 on 2015/06/13.
//  Copyright (c) 2015年 m18dev. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    var lm: CLLocationManager! = nil

    @IBAction func onPushButtonClick(sender: AnyObject) {
        lm = CLLocationManager()
        lm.delegate = self
        //位置情報取得の可否。バックグラウンドで実行中の場合にもアプリが位置情報を利用することを許可する
        lm.requestAlwaysAuthorization()
        //位置情報の精度
        lm.desiredAccuracy = kCLLocationAccuracyBest
        //位置情報取得間隔(m)
        lm.distanceFilter = 300
        
        lm.startUpdatingLocation()
    }
    
    //
    // 位置情報取得成功時
    //
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!){
        let longitude = newLocation.coordinate.longitude
        let latitude = newLocation.coordinate.latitude
        
        // 現在地の最寄駅取得
        searchNearStation(longitude, latitude: latitude)
    }
    
    //
    // 位置情報取得失敗時
    //
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        NSLog("location manager Error")
    }
    
    //
    // 最寄り駅検索
    //
    func searchNearStation(longitude: CLLocationDegrees, latitude: CLLocationDegrees) {
        NSLog("searching near station...")
        
        Alamofire.request(.GET, "http://express.heartrails.com/api/json", parameters: [
                "method": "getStations",
                "x": longitude,
                "y": latitude
            ])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { (_, _, json, error) in
                if(error != nil) {
                    println("[ERROR] searchNearStation: \(error)")
                    //self.loading.text = "Internet appears down!"
                } else {
                    let data = JSON(json!)
                    
                    // 最寄駅
                    if let nearStation = data["response"]["station"][0]["name"].string {
                        println("[SUCCESS] nearStaion: \(nearStation)")
                        // 終電時間検索
                        self.searchShudenTime(nearStation)
                    } else {
                        println("[ERROR] parse near staion failed")
                    }
                }
            }
    }
    
    //
    // 終電時間検索
    //
    func searchShudenTime(nearStation: String) {
        NSLog("searching shuden time...")
        
        let userId = 1 // とりあえず決め打ち
        
        // TODO: 実機でないと現在地を取得できないので、実機を使わざるを得ないのだが、そうするとlocalhostにつなぐのめんどい。。
        // herokuにあげてもらわないとかなあ
        Alamofire.request(.GET, "http://localhost:3000/api/last_train.json", parameters: ["user_id": userId])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { (_, _, json, error) in
                if(error != nil) {
                    println("[ERROR] searchShudenTime: \(error)")
                    //self.loading.text = "Internet appears down!"
                } else {
                    println("[SUCCESS] searchShudenTime")
                    println(json)
                    
                    // 終電通知が必要か？
                    let isNotificationRequired = true
                    
                    if isNotificationRequired {
                        self.notifyShudenTime()
                    }
                }
            }
    }
    
    //
    // 終電までの時間を通知
    //
    func notifyShudenTime() {
        NSLog("notify shuden time...")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

