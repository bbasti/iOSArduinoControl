//
//  main.swift
//  iOSArduinoControl macOS
//
//  Created by Philipp Gabriel on 26.09.16.
//  Copyright © 2016 4AHIT. All rights reserved.
//

import Foundation

enum Mode {
    case WriteLED(Int?, Bool)
    case ReadLED
    case List
}

class BluetoothConvenienceMac: BluetoothHelper {
    
    var bluetoothConv: BluetoothConvenience!
    var device: String?
    var mode: Mode?
    
    func start(mode: Mode, device: String?) {
        self.mode = mode
        self.device = device
        
        bluetoothConv = BluetoothConvenience(delegate: self)
    }
    
    func receive(device name: String, uuid: String) {
        if case .List = mode! {
            print(uuid)
        } else if case .ReadLED = mode!, self.device == device {
            bluetoothConv.connectToDevice(uuid: uuid)
        }
    }
    
    func error(description: String) {
        print(description)
    }
    
    func updateUI(update: UpdateInterface) {
        if case .Switch(let mode) = update {
            print(mode)
        }
    }
    
    func connected() {
        if case .WriteLED(let brightness, let state) = mode! {
            bluetoothConv.updateLED(powerState: state, brightness: brightness!)
        }
    }
}

let arguments = CommandLine.arguments
let bluetoothConvMac = BluetoothConvenienceMac()

if arguments[0] == "led", arguments[1] == "read" {
    bluetoothConvMac.start(mode: .ReadLED, device: arguments[2])
} else if arguments[0] == "led", arguments[1] == "write" {
    bluetoothConvMac.start(mode: .WriteLED(Int(arguments[3]), Bool(arguments[4])!), device: arguments[2])
} else if arguments[0] == "list" {
    bluetoothConvMac.start(mode: .List, device: nil)
}
