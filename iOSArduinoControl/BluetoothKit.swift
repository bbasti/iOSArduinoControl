//
//  BluetoothKit.swift
//  iOSArduinoControl
//
//  Created by Philipp Gabriel on 28.05.16.
//  Copyright © 2016 Philipp Gabriel. All rights reserved.
//

import CoreBluetooth

class BluetoothKit: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    let service: String
    let characteristic: String
    
    var delegate: BluetoothRaw?
    var peripherals = [String: (peripheral: CBPeripheral, characteristic: CBCharacteristic?)]()
    private var manager: CBCentralManager!
    
    init(service: String, characteristic: String) {
        self.service = service
        self.characteristic = characteristic
        super.init()
        manager = CBCentralManager(delegate: self, queue: nil)
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            manager.scanForPeripherals(withServices: nil, options: nil)
            break
        default:
            delegate?.error(description: "Bluetooth returned with status: " + String(central.state.rawValue))
            break
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        guard let name = peripheral.name else { return }
        peripheral.delegate = self
        peripherals[peripheral.identifier.uuidString] = (peripheral, nil)
        delegate?.broadcast(for: name, uuid: peripheral.identifier.uuidString)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices(nil)
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        if error != nil {
            delegate?.error(description: error.debugDescription)
            return
        }
        
        guard let services = peripheral.services else {
            delegate?.error(description: "No services for this device were found!")
            return
        }
        
        let result = services.first { service -> Bool in
            return service.uuid.uuidString == self.service
        }
        
        guard let unwrapped = result else {
            delegate?.error(description: "No fitting services found for this device!")
            return
        }
        
        peripheral.discoverCharacteristics(nil, for: unwrapped)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        if error != nil {
            delegate?.error(description: error.debugDescription)
            return
        }
        
        guard let characteristics = service.characteristics else {
            delegate?.error(description: "No characteristics for this device were found!")
            return
        }
        
        let result = characteristics.first { characteristic -> Bool in
            return characteristic.uuid.uuidString == self.characteristic
        }
        
        guard let unwrapped = result else {
            delegate?.error(description: "No fitting characteristics found for this device!")
            return
        }
        let id = peripheral.identifier.uuidString
        peripherals[id] = ((peripherals[id]?.peripheral)!, unwrapped)
        peripheral.setNotifyValue(true, for: unwrapped)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        if error != nil {
            delegate?.error(description: error.debugDescription)
            return
        }
        
        guard let data = characteristic.value else {
            delegate?.error(description: "Received data with no context!")
            return
        }
        
        let strings = String(data: data, encoding: String.Encoding.utf8)!.components(separatedBy: "\r\n")
        for string in strings {
            delegate?.received(data: string)
        }
    }
    
    func startReading(identifier: String) {
        manager.connect((peripherals[identifier]?.0)!, options: nil)
        manager.stopScan()
    }

    func write(data: String, uuid: String) {
        guard let raw = (data + "\r\n").data(using: String.Encoding.utf8) else {
            delegate?.error(description: "Could not convert data to UTF8!")
            return
        }
        
        guard let characteristic = peripherals[uuid]?.characteristic else {
            delegate?.error(description: "No characteristics were found for this device!")
            return
        }
        
        peripherals[uuid]?.peripheral.writeValue(raw, for: characteristic, type: .withoutResponse)
    }

}

protocol BluetoothRaw {
    func broadcast(for device: String, uuid: String)
    func received(data: String)
    func error(description: String)
}
