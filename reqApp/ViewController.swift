//
//  ViewController.swift
//  reqApp
//
//  Created by 정기웅 on 2020/05/18.
//  Copyright © 2020 정기웅. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let shareDefaults = UserDefaults(suiteName: "group.reqGroup")

        shareDefaults!.set("testApp", forKey:"name")
    }

    
}

