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
    
<<<<<<< HEAD
    var potiValue: Int
    var distanceValue: Int
    var switchState: Bool
    var motionState: Bool
    
    func bluetoothManager(didReceiveDataFromDevice data: String){
        var token: [String]
        
        if(data.hasPrefix("switch")){
            switchState = data.hasSuffix("on")
            switchState = !data.hasSuffix("off")
        } else if(data.hasPrefix("motion")){
            motionState = data.hasSuffix("on")
            motionState = !data.hasSuffix("off")
        } else if(data.hasPrefix("poti")){
            token = data.componentsSeparatedByString(" ")
            potiValue = Int(token[1])!
        } else if(data.hasPrefix("dist")){
            token = data.componentsSeparatedByString(" ")
            distanceValue = Int(token[1])!
=======
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
>>>>>>> origin/master
        }
    }

    func connectToDevice(uuid: String) {
        bluetoothKit.startReading(identifier: uuid)
        activePeripheral = peripherals[uuid]
    }
    
    func updateLED(powerState: Bool, brightness: Int) {}
    func servoMotor(degrees: Int) {}
    func stepMotor(turns: Int, speed: Int) {}
}

protocol BluetoothHelper {
    func receiveDevice(name: String, uuid: String)
    func handleError(error: String)
    //Function for updating UI elements
}
