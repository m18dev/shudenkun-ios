//
//  HotelTableViewController.swift
//  shudenkun
//
//  Created by 前原 秀徳 on 2015/06/16.
//  Copyright (c) 2015年 m18dev. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class HotelTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        //
        // 近隣ホテル検索
        //
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
                    
                    println(data)
                    
                    // ホテル一覧
                    for (index: String, hotel: JSON) in data["hotels"] {
                        let hotelInfo = hotel[0]["hotelBasicInfo"]
                            
                        println(hotelInfo)
                        println(hotelInfo["hotelName"].stringValue)
                        println(hotelInfo["roomImageUrl"].stringValue)
                        println(hotelInfo["telephoneNo"].stringValue)
                        println(hotelInfo["access"].stringValue)
                        println(hotelInfo["longitude"].stringValue)
                        println(hotelInfo["latitude"].stringValue)
                    }
                }
            }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 0
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
