//
//  BluetoothKit.swift
//  iOSArduinoControl
//
//  Created by Philipp Gabriel on 28.05.16.
//  Copyright © 2016 Philipp Gabriel. All rights reserved.
//

import CoreBluetooth

//TODO remove all other peripheral collections and make this one public
class BluetoothKit: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {

    static let sharedManager = BluetoothKit()
    var brDelegate: BluetoothReceiver!

    private var manager: CBCentralManager!
    private var peripherals = [String: (CBPeripheral, CBCharacteristic?)]()

    override init() {
        super.init()
        manager = CBCentralManager(delegate: self, queue: nil)
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            manager.scanForPeripherals(withServices: nil, options: nil)
            break
        default:
            //TODO Implement error handling
            break
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : AnyObject], rssi RSSI: NSNumber) {
        if peripheral.name == nil { return }
        peripheral.delegate = self
        peripherals[peripheral.identifier.uuidString] = (peripheral, nil)
        brDelegate.bluetoothManager(didReceiveBroadcastForDevice: peripheral.name!, uuid: peripheral.identifier.uuidString, peripheral: peripheral)
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices(nil)
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        for service in peripheral.services! {
            if service.uuid.uuidString != "FFE0" { continue }
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: NSError?) {
        for characteristic in service.characteristics! {
            if characteristic.uuid.uuidString != "FFE1" { continue }
            peripherals[peripheral.identifier.uuidString] = ((peripherals[peripheral.identifier.uuidString]?.0)!, characteristic)
            peripheral.setNotifyValue(true, for: characteristic)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: NSError?) {
        let strings = String(data: characteristic.value!, encoding: String.Encoding.utf8)!.components(separatedBy: "\r\n")
        for string in strings {
            if string.characters.count <= 1 { continue }
            brDelegate.bluetoothManager(didReceiveDataFromDevice: string)
        }
    }

    func stopScan() {
        manager.stopScan()
    }

    func startReading(identifier: String) {
        manager.connect((peripherals[identifier]?.0)!, options: nil)
        manager.stopScan()
    }

    func write(data: String, uuid: String) {
        peripherals[uuid]?.0.writeValue((data + "\r\n").data(using: String.Encoding.utf8)!, for: (peripherals[uuid]?.1)!, type: .withoutResponse)
    }

}

protocol BluetoothReceiver {
    func bluetoothManager(didReceiveBroadcastForDevice name: String, uuid: String, peripheral: CBPeripheral)
    func bluetoothManager(didReceiveDataFromDevice data: String)
}
