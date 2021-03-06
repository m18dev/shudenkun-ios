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

    @IBOutlet weak var shudenIntervalSlider: UISlider!
    @IBOutlet weak var shudenIntervalLabel: UILabel!
    @IBOutlet weak var nearStationLabel: UILabel!
    
    @IBAction func shudenIntervalSliderValueChanged(sender: UISlider) {
        let val = Int(sender.value)
        shudenIntervalLabel.text = "\(val)"
    }
    
    @IBAction func onPushButtonClick(sender: AnyObject) {
        NSLog("button clicked...")
        
        // NSUserDefaultsに終電通知までの時間を保存
        let shudenInterval = Int(shudenIntervalSlider.value)
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(shudenInterval, forKey:"SHUDEN_INTERVAL")
        defaults.synchronize()
        
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
        NSLog("location manager Error \(error)")
    }
    
    //
    // 最寄り駅検索
    //
    func searchNearStation(longitude: CLLocationDegrees, latitude: CLLocationDegrees) {
        NSLog("searching near station...long: \(longitude), lat: \(latitude)")
        
        Alamofire.request(.GET, "https://express.heartrails.com/api/json", parameters: [
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
                        
                        // 現在地情報を保存
                        let defaults = NSUserDefaults.standardUserDefaults()
                        defaults.setObject(nearStation, forKey:"NEAR_STATION")
                        defaults.setDouble(longitude, forKey:"CURRENT_LONGITUDE")
                        defaults.setDouble(latitude, forKey:"CURRENT_LATITUDE")
                        defaults.synchronize()
                        
                        self.nearStationLabel.text = nearStation
       
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
        
        let userId = 5 // とりあえず決め打ち
        
        Alamofire.request(.GET, "https://shudenkun.herokuapp.com/api/last_train.json", parameters: [
                "user_id": userId,
                "depature": nearStation
            ])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { (_, _, json, error) in
                if(error != nil) {
                    println("[ERROR] searchShudenTime: \(error)")
                    //self.loading.text = "Internet appears down!"
                } else {
                    let data = JSON(json!)
                    
                    // 終電時間
                    if let shudenTime = data["depature_at"].string {
                        println("[SUCCESS] shudenTime: \(shudenTime)")
                        
                        // 終電までの残り時間
                        let remainMin = data["remain_min"].intValue
                        // 自宅駅
                        let destinationStation = data["destination"].stringValue
                        
                        // 終電通知が必要か？
                        let shudenInterval : Int! = NSUserDefaults.standardUserDefaults().integerForKey("SHUDEN_INTERVAL")
                        let isNotificationRequired = remainMin <= shudenInterval ? true : false
                        
                        if isNotificationRequired {
                            self.notifyShudenTime(shudenTime, remainMin: remainMin, nearStation: nearStation, destinationStation: destinationStation)
                        } else {
                            println("notification is not required")
                        }
                    } else {
                        println("[ERROR] parse shuden time failed")
                    }
                }
            }
    }
    
    //
    // 終電発車時間と残り時間を通知
    //
    func notifyShudenTime(shudenTime: String, remainMin: Int, nearStation: String, destinationStation: String) {
        NSLog("notify shuden time...")
        println(shudenTime)
        println(remainMin)
        
        var notification = UILocalNotification()
        notification.fireDate = NSDate()	// すぐに通知したいので現在時刻を取得
        notification.timeZone = NSTimeZone.defaultTimeZone()
        notification.alertBody = "\(nearStation)から\(destinationStation) \n 終電まで残り：\(remainMin)分 \n 発車時間：\(shudenTime)"
        notification.alertAction = "OK"
        notification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
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

