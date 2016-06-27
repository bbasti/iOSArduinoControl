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
            if dataString.hasSuffix("on") { switchState = true }
            else if dataString.hasSuffix("off") { switchState = false }
            if switchState == nil { return }
            bhDelegate.updateUI(update: .Switch(switchState!))
        } else if dataString.hasPrefix("motion") {
            if dataString.hasSuffix("on") { motionState = true }
            else if dataString.hasSuffix("off") { motionState = false }
            if motionState == nil { return }
            bhDelegate.updateUI(update: .Motion(motionState!))
        } else if dataString.hasPrefix("poti") {
            token = dataString.components(separatedBy: " ")
            if token.count != 2 { return }
            potiValue = Int(token[1])
            if potiValue == nil { return }
            bhDelegate.updateUI(update: .Poti(potiValue!))
        } else if dataString.hasPrefix("dist") {
            token = dataString.components(separatedBy: " ")
            if token.count != 2 { return }
            distanceValue = Int(token[1])
            if distanceValue == nil { return }
            bhDelegate.updateUI(update: .Distance(distanceValue!))
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
    
    func customCommand(command: String){
        bluetoothKit.write(data: command, uuid: activePeripheral.identifier.uuidString)
    }
}

enum UpdateInterface {
    case Switch(Bool)
    case Motion(Bool)
    case Poti(Int)
    case Distance(Int)
}

protocol BluetoothHelper {
    func receiveDevice(name: String, uuid: String)
    func handleError(error: String)
    func updateUI(update: UpdateInterface)
}
