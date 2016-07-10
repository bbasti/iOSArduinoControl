//
//  InputCommandsController.swift
//  iOSArduinoControl
//
//  Created by Damir Kozica on 26.06.16.
//  Copyright © 2016 Philipp Gabriel. All rights reserved.
//

import UIKit

class InputCommandsController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var commandVal: UITextField!
    @IBOutlet weak var textField: UITextView!

    var tapGesture = UITapGestureRecognizer()
    var commandsExecuted = ""

    //TODO update interface to make it look more like a ClI (blinking cursor)
    @IBAction func onCommandSent(_ sender: AnyObject) {
        commandsExecuted += "ardCLI# " + commandVal.text! + "\n"
        textField.text = commandsExecuted
        ScanTableViewController.bConv.customCommand(command: commandVal.text!)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tapGesture.delegate = self
        self.tapGesture.addTarget(self, action: #selector(handleTap))

        self.view.addGestureRecognizer(tapGesture)

        textField.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func handleTap(sender: UITapGestureRecognizer? = nil) {
        self.commandVal.resignFirstResponder()
    }

}
