//
//  BluetoothKit.swift
//  iOSArduinoControl
//
//  Created by Philipp Gabriel on 28.05.16.
//  Copyright © 2016 Philipp Gabriel. All rights reserved.
//

import CoreBluetooth

//TODO implement error handling (didWrite shit)
class BluetoothKit: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    static let sharedManager = BluetoothKit()
    var brDelegate: BluetoothReceiver!
    
    private var manager: CBCentralManager!
    private var dataString = String()
    var peripherals = [String: (CBPeripheral, CBCharacteristic?)]()
    
    override init() {
        super.init()
        manager = CBCentralManager(delegate: self, queue: nil)
    }
    
    //TODO only start scanning when state changed to good one
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        manager.scanForPeripherals(withServices: nil, options: nil)
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
    
    //TODO sometimes a block has more than 6 lines (especially at the beginning)
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: NSError?) {
        dataString += String(data: characteristic.value!, encoding: String.Encoding.utf8)!.replacingOccurrences(of: "\n", with: "")
        brDelegate.bluetoothManager(didReceiveDataFromDevice: dataString)
    }
    
    func startScan() -> Bool {
        if brDelegate == nil {
            return false
        }
        manager.scanForPeripherals(withServices: nil, options: nil)
        return true
    }
    
    func stopScan() {
        manager.stopScan()
    }
    
    //TODO wait until connection finished
    func startReading(_ identifier: String) {
        manager.connect((peripherals[identifier]?.0)!, options: nil)
        manager.stopScan()
    }
    
    func write(_ data: String, uuid: String) {
        peripherals[uuid]?.0.writeValue((data + "\r\n").data(using: String.Encoding.utf8)!, for: (peripherals[uuid]?.1)!, type: .withoutResponse)
    }
    
}

protocol BluetoothReceiver {
    func bluetoothManager(didReceiveBroadcastForDevice name: String, uuid: String, peripheral: CBPeripheral)
    func bluetoothManager(didReceiveDataFromDevice data: String)
}
