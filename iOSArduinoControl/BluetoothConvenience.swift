//
//  BluetoothConvenience.swift
//  iOSArduinoControl
//
//  Created by Bastian Brandstötter on 07/06/16.
//  Copyright © 2016 Bastian Brandstötter. All rights reserved.
//

import CoreBluetooth

class BluetoothConvenience: BluetoothRaw {

    let delegate: BluetoothHelper
    var bluetoothKit: BluetoothKit!
    var activePeripheral: CBPeripheral!

    init(delegate: BluetoothHelper) {
        self.delegate = delegate
        
        defer {
            self.bluetoothKit = BluetoothKit(service: "FFE0", characteristic: "FFE1", delegate: self)
            bluetoothKit.startScan()
        }
    }

    func connected() {
        delegate.connected()
    }
    
    func broadcast(for device: String, uuid: String) {
        delegate.receive(device: device, uuid: uuid)
    }
    
    func error(description: String) {
        delegate.error(description: description)
    }
    
    func received(data: String) {

        if data.hasPrefix("switch") {
            delegate.updateUI(update: .Switch(data.hasSuffix("on")))
        } else if data.hasPrefix("motion") {
            delegate.updateUI(update: .Motion(data.hasSuffix("on")))
        } else if data.hasPrefix("poti") {
            let split = String(describing: data.characters.split(separator: " ").last)
            guard let raw = Int(split) else {
                delegate.error(description: "A command was found which didn't conform to guidelines!")
                return
            }
            delegate.updateUI(update: .Poti(raw))
        } else if data.hasPrefix("dist") {
            let split = String(describing: data.characters.split(separator: " ").last)
            guard let raw = Int(split) else {
                delegate.error(description: "A command was found which didn't conform to guidelines!")
                return
            }
            delegate.updateUI(update: .Distance(raw))
        }
    }

    func connectToDevice(uuid: String) {
        bluetoothKit.startReading(identifier: uuid)
        activePeripheral = bluetoothKit.peripherals[uuid]?.peripheral
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

    func customCommand(command: String) {
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
    func connected()
    func receive(device name: String, uuid: String)
    func error(description: String)
    func updateUI(update: UpdateInterface)
}
