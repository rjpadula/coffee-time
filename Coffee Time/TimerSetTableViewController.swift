//
//  TimerSetTableViewController.swift
//  Coffee Time
//
//  Created by Robert J Padula on 10/14/17.
//  Copyright © 2017 Deep Dish Technology. All rights reserved.
//

import UIKit

class TimerSetTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        return timerViewController?.timerSets.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "timer", for: indexPath)

        if let timerSet = timerViewController?.timerSets[indexPath.row] {
            cell.textLabel?.text = timerSet.label
        }

        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let timerSet = timerViewController?.timerSets[indexPath.row] {
            timerViewController?.timerSet = timerSet
        }
    }

    weak var timerViewController:TimerViewController?
}
