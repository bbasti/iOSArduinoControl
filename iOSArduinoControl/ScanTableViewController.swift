//
//  ScanTableViewController.swift
//  iOSArduinoControl
//
//  Created by Damir Kozica on 26.06.16.
//  Copyright © 2016 Philipp Gabriel. All rights reserved.
//

import UIKit

class ScanTableViewController: UITableViewController {
    
    var bkManager = BluetoothKit.sharedManager
    var startedScan: Bool!

    override func viewDidLoad() {
        super.viewDidLoad()

        //Start scanning here
        self.startedScan = bkManager.startScan()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.bkManager.peripherals.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        
        //Configure text and subtext
      /*  cell.textLabel?.text = self.bkManager.peripherals.map($0)
        cell.detailTextLabel?.text = self.bkManager.peripherals[indexPath.row].0 */


        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ArdUIController = self.storyboard?.instantiateViewController(withIdentifier: "ArdUIController")
        
        
        //if connected, push to ArdUIController
        
        
      //  self.navigationController?.pushViewController(ArdUIController!, animated: true)
    }
    

}
