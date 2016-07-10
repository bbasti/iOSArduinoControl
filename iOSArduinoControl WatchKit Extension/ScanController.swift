//
//  InterfaceController.swift
//  iOSArduinoControl WatchKit Extension
//
//  Created by Philipp Gabriel on 20.05.16.
//  Copyright © 2016 Philipp Gabriel. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class ScanController: WKInterfaceController, WCSessionDelegate {
    
    @IBOutlet var table: WKInterfaceTable!
    var session: WCSession? {
        didSet {
            if let session = session {
                session.delegate = self
                session.activate()
            }
        }
    }
    
    var devices = [(name:String, uuid:String)]()
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: NSError?) {
        
    }
    
    override func awake(withContext context: AnyObject?) {
        super.awake(withContext: context)
        session = WCSession.default()
        session?.sendMessage(["scan":true], replyHandler: {
            data in
            self.devices = data.map({($0, $1 as! String)})
            DispatchQueue.main.async {
                self.table.setNumberOfRows(self.devices.count, withRowType: "ScanRow")
                for (index, device) in self.devices.enumerated() {
                    let row = self.table.rowController(at: index) as! ScanRow
                    row.name.setText(device.name)
                    row.uuid.setText(device.uuid)
                }
            }
            }, errorHandler: nil)
    }
    
    override func willActivate() {
        super.willActivate()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
}
