//
//  BluetoothConvenience.swift
//  iOSArduinoControl
//
//  Created by Bastian Brandstötter on 07/06/16.
//  Copyright © 2016 Bastian Brandstötter. All rights reserved.
//

import CoreBluetooth

class BluetoothConvenience: BluetoothReceiver {
    
    let bluetoothKit = BluetoothKit.sharedManager
    let bhDelegate: BluetoothHelper!
    
    var peripherals = [String: CBPeripheral]()
    var activePeripheral: CBPeripheral!
    
    
    init(bhDelegate: BluetoothHelper) {
        self.bhDelegate = bhDelegate
        bluetoothKit.brDelegate = self
    }
    
    func bluetoothManager(didReceiveBroadcastForDevice name: String, uuid: String, peripheral: CBPeripheral) {
        peripherals[uuid] = peripheral
        bhDelegate.receiveDevice(name: name, uuid: uuid)
    }
    
    func bluetoothManager(didReceiveDataFromDevice data: String) {
        var potiValue: Int?
        var distanceValue: Int?
        var switchState: Bool?
        var motionState: Bool?
        
        let dataString = data.replacingOccurrences(of: "\r", with: "")
        var token: [String]
        
        if dataString.hasPrefix("switch") {
            switchState = dataString.hasSuffix("on")
            switchState = !dataString.hasSuffix("off")
            bhDelegate.updateUI(update: .Switch, value: switchState!)
        } else if dataString.hasPrefix("motion") {
            motionState = dataString.hasSuffix("on")
            motionState = !dataString.hasSuffix("off")
            bhDelegate.updateUI(update: .Motion, value: motionState!)
        } else if dataString.hasPrefix("poti") {
            token = dataString.components(separatedBy: " ")
            if token.count != 2 { return }
            potiValue = Int(token[1])
            if potiValue == nil { return }
            bhDelegate.updateUI(update: .Poti, value: potiValue!)
        } else if dataString.hasPrefix("dist") {
            token = dataString.components(separatedBy: " ")
            if token.count != 2 { return }
            distanceValue = Int(token[1])
            if distanceValue == nil { return }
            bhDelegate.updateUI(update: .Distance, value: distanceValue!)
        }
    }
    
    /*func bluetoothManager(didReceiveDataFromDevice data: String){
        let dataString = data.replacingOccurrences(of: "\r", with: "")
        if dataString.hasPrefix("switch"){
            if(dataString.hasSuffix("on")){
                bhDelegate.updateUI(update: .Switch, value: true)
            } else if dataString.hasSuffix("off") {
                bhDelegate.updateUI(update: .Switch, value: false)
            }
        } else if dataString.hasPrefix("motion"){
            if dataString.hasSuffix("on") {
                bhDelegate.updateUI(update: .Motion, value: true)
            } else if dataString.hasSuffix("off") {
                bhDelegate.updateUI(update: .Motion, value: false)
            }
        } else if dataString.hasPrefix("poti") {
            var token = dataString.components(separatedBy: " ")
            if token.count != 2 { return }
            let potiValue = Int(token[1])
            if potiValue == nil { return }
            bhDelegate.updateUI(update: .Poti, value: potiValue!)
        } else if dataString.hasPrefix("dist") {
            var token = dataString.components(separatedBy: " ")
            if token.count != 2 { return }
            let distanceValue = Int(token[1])
            if distanceValue == nil { return }
            bhDelegate.updateUI(update: .Distance, value: distanceValue!)
        }
    }*/
    
    func connectToDevice(uuid: String) {
        bluetoothKit.startReading(identifier: uuid)
        activePeripheral = peripherals[uuid]
    }
    
    func updateLED(powerState: Bool, brightness: Int) {
        var onOrOff = "on"
        if !powerState { onOrOff = "off" }
        bluetoothKit.write(data: "led \(onOrOff) 1", uuid: activePeripheral.identifier.uuidString)
        bluetoothKit.write(data: "pwm \(brightness)", uuid: activePeripheral.identifier.uuidString)
    }
    func servoMotor(degrees: Int) {}
    func stepMotor(turns: Int, speed: Int) {}
}

enum UpdateInterface {
    case Switch
    case Motion
    case Poti
    case Distance
}

protocol BluetoothHelper {
    func receiveDevice(name: String, uuid: String)
    func handleError(error: String)
    func updateUI(update: UpdateInterface, value: AnyObject)
}
