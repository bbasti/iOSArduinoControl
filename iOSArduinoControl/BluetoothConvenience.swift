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
    
    func connectToDevice(uuid: String) {
        bluetoothKit.startReading(identifier: uuid)
        activePeripheral = peripherals[uuid]
    }
    
    func updateLED(powerState: Bool, brightness: Int) {
        let onOrOff = powerState ? "on" : "off"
        bluetoothKit.write(data: "led \(onOrOff) 1", uuid: activePeripheral.identifier.uuidString)
        bluetoothKit.write(data: "pwm \(brightness)", uuid: activePeripheral.identifier.uuidString)
    }
    
    func servoMotor(degrees: Int) {
        bluetoothKit.write(data: "servo \(degrees)", uuid: activePeripheral.identifier.uuidString)
    }
    
    func stepMotor(turns: Int, speed: Int) {
        bluetoothKit.write(data: "step \(turns) \(speed)", uuid: activePeripheral.identifier.uuidString)
    }
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
