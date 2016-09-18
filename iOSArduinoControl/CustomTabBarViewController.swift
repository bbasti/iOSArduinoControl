//
//  ViewController.swift
//  iOSArduinoControl
//
//  Created by Damir Kozica on 24.06.16.
//  Copyright © 2016 Philipp Gabriel. All rights reserved.
//

import UIKit
import FoldingTabBar

class CustomTabBarViewController: YALFoldingTabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //leftBarItems
        let firstItem = YALTabBarItem(
            itemImage: #imageLiteral(resourceName: "Rocket-w"),
            leftItemImage: nil,
            rightItemImage: nil
        )
        self.leftBarItems = [firstItem!]

        //rightBarItems
        let secondItem = YALTabBarItem(
            itemImage: #imageLiteral(resourceName: "Keyboard-w"),
            leftItemImage: nil,
            rightItemImage: nil
        )
        self.rightBarItems = [secondItem!]

        self.centerButtonImage = #imageLiteral(resourceName: "Plus")

        self.tabBarView.tabBarColor = UIColor(
            red: 72.0/255.0,
            green: 211.0/255.0,
            blue: 178.0/255.0,
            alpha: 1
        )

        self.tabBarView.dotColor = UIColor(
            red: 94.0/255.0,
            green: 91.0/255.0,
            blue: 149.0/255.0,
            alpha: 1
        )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
