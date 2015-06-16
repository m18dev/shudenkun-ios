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

class HotelTableViewController: UITableViewController, RakutenAPIControllerProtocol {

    @IBOutlet var hotelTableView: UITableView!
    
    var api : RakutenAPIController?
    var hotels = [Hotel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        //
        // 近隣ホテル検索
        //
        api = RakutenAPIController(delegate: self)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        api!.searchHotels()
    }
    
    // RakutenApiControllerProtocol
    func didReceiveRakutenAPIResults(data: JSON) {
        dispatch_async(dispatch_get_main_queue(), {
            for (index: String, hotel: JSON) in data["hotels"] {
                let hotelInfo = hotel[0]["hotelBasicInfo"]
                    
                let name = hotelInfo["hotelName"].stringValue
                let roomImageUrl = hotelInfo["roomImageUrl"].stringValue
                let telephoneNo = hotelInfo["telephoneNo"].stringValue
                
                var hotel = Hotel(
                    name: name,
                    roomImageUrl: roomImageUrl,
                    telephoneNo: telephoneNo
                )
                
                println(hotel.name)
                
                self.hotels.append(hotel)
            }
            
            self.hotelTableView!.reloadData()
        })
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
        return hotels.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HotelTableViewCell", forIndexPath: indexPath) as! UITableViewCell
        
        println(cell)

        // Configure the cell...
        let hotel = self.hotels[indexPath.row]
        cell.textLabel?.text = hotel.name
        //cell.imageView?.image = UIImage(named: "Blank52")

        return cell
    }

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
