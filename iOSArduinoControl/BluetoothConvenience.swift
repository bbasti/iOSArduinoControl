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
