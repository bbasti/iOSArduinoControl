//
//  ArdUIController.swift
//  iOSArduinoControl
//
//  Created by Damir Kozica on 23.06.16.
//  Copyright © 2016 Philipp Gabriel. All rights reserved.
//

import UIKit
import SAMultisectorControl

class ArdUIController: UIViewController {
    
    @IBOutlet weak var titleForSliders: UILabel!
    var mutableTitle = NSMutableAttributedString()
    
    @IBOutlet weak var multisector: SAMultisectorControl!

    @IBOutlet weak var distanceVal: UILabel!
    @IBOutlet weak var buttonState: UILabel!
    @IBOutlet weak var motionSensorVal: UILabel!
    @IBOutlet weak var pmVal: UILabel!

    let blueColor = UIColor(red: 0.0, green:168.0/255.0, blue:255.0/255.0, alpha: 1.0)
    let greenColor = UIColor(red:29.0/255.0, green:207.0/255.0, blue:0.0, alpha: 1.0)
    
    let lighRedColor = UIColor(red: 199/255, green: 50/255, blue: 93/255, alpha: 1.0)
    let lighGreenColor = UIColor(red: 56/255, green: 205/255, blue: 66/255, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ScanTableViewController.ardControl = self
        
        //Setting up title and sliders
        //Tsitle
        mutableTitle = NSMutableAttributedString(string: "Adjust motor speed and LED light", attributes: [NSFontAttributeName:UIFont(name: "Apple SD Gothic Neo", size: 20.0)!])
        mutableTitle.addAttribute(NSForegroundColorAttributeName, value: blueColor, range: NSRange(location:7,length:11))
        mutableTitle.addAttribute(NSForegroundColorAttributeName, value: greenColor, range: NSRange(location:23,length:9))
        self.titleForSliders.attributedText = mutableTitle

        
        //Slider for motor
        let sector1 = SAMultisectorSector(color: blueColor, maxValue: 180.0)!
        sector1.tag = 0
        sector1.startValue = 0.0
        sector1.endValue = 180.0
        
        
        //Slider for LED
        let sector2 = SAMultisectorSector(color: greenColor, maxValue: 100.0)!
        sector2.tag = 1
        sector1.startValue = 0.0
        sector1.endValue = 100.0
        
        self.multisector.addSector(sector2)
        self.multisector.addSector(sector1)
    
    }
    
    //For sliders
    @IBAction func onValuesChange(_ sender: SAMultisectorControl) {
        for sector in self.multisector.sectors{
            
            let value: Int = Int(sector.endValue - sector.startValue)
            
            //If user changes motor speed value, use variable value
            if(sector.tag == 0){
                //send to BLE device
                print(value)
            }
            
            //If user changes LED light value, use variable value
            if(sector.tag == 1){
                //send to BLE device
                print(value)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateUI(update: UpdateInterface) {
        switch update {
        case .Distance(let number):
            distanceVal.text = String(number)
            break
        case .Motion(let bool):
            let color = (bool) ? lighGreenColor : lighRedColor
            let string = (bool) ? "ON" : "OFF"
            motionSensorVal.tintColor = color
            motionSensorVal.text = string
            break
        case .Poti(let number):
            pmVal.text = String(number)
            break
        case .Switch(let bool):
            let color = (bool) ? lighGreenColor : lighRedColor
            let string = (bool) ? "ON" : "OFF"
            buttonState.textColor = color
            buttonState.text = string
            break
        }
    }

}
