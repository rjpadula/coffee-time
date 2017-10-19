//
//  FirstViewController.swift
//  Coffee Time
//
//  Created by Robert J Padula on 9/8/17.
//  Copyright © 2017 Deep Dish Technology. All rights reserved.
//

import UIKit


class TimerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadJSONfiles()
        
        timerSet = timerSets.first
        remainingTimeLabel.text = "Press Start"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadJSONfiles() {
        if let files = Bundle.main.urls(forResourcesWithExtension: "json", subdirectory: nil) {
        
            timerSets = files.flatMap { TimerSet(url:$0) }
        }
    }
    @IBAction func startPressed(_ sender: Any) {
        if (timer != nil) {
            // We are already running - deal with this later
            
        } else {
            guard let timerSet = timerSet else {
                return
            }
            // Start the timer
            index = timerSet.slices.startIndex
            remain = timerSet.slices[index].duration
            timer = Timer.scheduledTimer(timeInterval: period, target: self, selector: #selector(timerTick), userInfo: nil, repeats: true)
        }
    }
    
    @IBAction func timerTick(_ timer:Timer) {
        guard let timerSet = timerSet else {
            return
        }
        // How long ?
        remain -= period
        if remain <= 0.0 {
            // End of the time period!
            index += 1
            if index == timerSet.slices.endIndex {
                // That's the total end of everything!
                stageLabel.text = "Done"
                timer.invalidate()
                self.timer = nil
            } else {
                // On to the next period
                stageLabel.text = timerSet.slices[index].label
                remain = timerSet.slices[index].duration
            }
        }
        remainingTimeLabel.text = String(remain)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let timerSetTableViewController = segue.destination as? TimerSetTableViewController {
            timerSetTableViewController.timerViewController = self
        }
    }

    @IBAction func unwindToMain(segue: UIStoryboardSegue) {
    }
    
    var timerSets = [TimerSet]()
    var timerSet: TimerSet? {
        didSet {
            if let timerSet = timerSet {
                stageLabel.text = timerSet.label
            } else {
                startButton.isEnabled = false
            }

        }
    }
    
    var index = 0
    var remain = 0.0
    let period = 1.0

    var timer:Timer?
    
    @IBOutlet weak var stageLabel: UILabel!
    @IBOutlet weak var remainingTimeLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!

}

