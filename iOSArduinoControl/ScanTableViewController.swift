//
//  ScanTableViewController.swift
//  iOSArduinoControl
//
//  Created by Damir Kozica on 26.06.16.
//  Copyright © 2016 Philipp Gabriel. All rights reserved.
//

import UIKit

class ScanTableViewController: UITableViewController, BluetoothHelper {
    
    var counter = 0
    var nameUpdate: String!
    var uuidUpdate: String!
    static var bConv: BluetoothConvenience!
    static var ardControl: ArdUIController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ScanTableViewController.bConv = BluetoothConvenience(bhDelegate: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return counter
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = nameUpdate
        cell.detailTextLabel?.text = uuidUpdate
        return cell
    }
    
    var ardUIController: UIViewController!
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ardUIController = self.storyboard?.instantiateViewController(withIdentifier: "ArdUIController")
        ScanTableViewController.bConv.connectToDevice(uuid: (tableView.cellForRow(at: indexPath)?.detailTextLabel?.text)!)
        self.present(ardUIController!, animated: true, completion: nil)
        //self.navigationController?.pushViewController(ArdUIController!, animated: true)
    }
    
    func receiveDevice(name: String, uuid: String) {
        counter += 1
        nameUpdate = name
        uuidUpdate = uuid
        self.tableView.reloadData()
    }
    
    //TODO popup notification
    func handleError(error: String) {
        print(error)
    }
    
    func updateUI(update: UpdateInterface) {
        ScanTableViewController.ardControl.updateUI(update: update)
    }
    
}
