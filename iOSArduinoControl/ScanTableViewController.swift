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
    static var bConv: BluetoothConvenience!
    static var ardControl: ArdUIController!
    
    var names = [Int: (String, String)]() //TODO deprecated
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ScanTableViewController.bConv = BluetoothConvenience(bhDelegate: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return counter
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = names[indexPath.row]?.0
        cell.detailTextLabel?.text = names[indexPath.row]?.1
        return cell
    }
    
    var ardUIController: UIViewController!
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ardUIController = self.storyboard?.instantiateViewController(withIdentifier: "ArdUIController")
        ScanTableViewController.bConv.connectToDevice(uuid: (tableView.cellForRow(at: indexPath)?.detailTextLabel?.text)!)
        self.present(ardUIController!, animated: true, completion: nil)
    }
    
    func receiveDevice(name: String, uuid: String) {
        names[counter] = (name, uuid)
        counter += 1
        self.tableView.reloadData()
    }
    
    //TODO Implement error handling here
    func handleError(error: String) {
        print(error)
    }
    
    func updateUI(update: UpdateInterface) {
        ScanTableViewController.ardControl.updateUI(update: update)
    }
    
}
