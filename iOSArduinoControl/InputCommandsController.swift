//
//  InputCommandsController.swift
//  iOSArduinoControl
//
//  Created by Damir Kozica on 26.06.16.
//  Copyright © 2016 Philipp Gabriel. All rights reserved.
//

import UIKit

class InputCommandsController: UIViewController {

    @IBOutlet weak var commandVal: UITextField!
    
    @IBAction func onCommandSent(_ sender: AnyObject) {
        ScanTableViewController.bConv.customCommand(command: commandVal.text!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
