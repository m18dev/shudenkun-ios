//
//  ViewController.swift
//  shudenkun
//
//  Created by 前原 秀徳 on 2015/06/13.
//  Copyright (c) 2015年 m18dev. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    @IBAction func onPushButtonClick(sender: AnyObject) {
        Alamofire
            .request(.GET, "http://localhost:3000/api/last_train.json", parameters: ["user_id": 1])
            .responseJSON { (_, _, JSON, _) in
                println(JSON)
            }
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

