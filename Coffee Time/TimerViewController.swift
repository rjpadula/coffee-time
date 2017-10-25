//
//  FirstViewController.swift
//  Coffee Time
//
//  Created by Robert J Padula on 9/8/17.
//  Copyright © 2017 Deep Dish Technology. All rights reserved.
//

import UIKit


class TimerViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadJSONfiles()
        
        timerSet = timerSets.first
        remainingTimeLabel.text = "Press Start"
        
        timeSliceCollectionView.dataSource = self
        timeSliceCollectionView.delegate = self
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

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let timerSet = timerSet {
            return timerSet.slices.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = timeSliceCollectionView.dequeueReusableCell(withReuseIdentifier: TimerSliceViewCell.reuseIdentifier, for: indexPath)
        if let cell = cell as? TimerSliceViewCell {
            if let timerSet = timerSet {
                cell.timeSlice = timerSet.slices[indexPath.row]
            } else {
                cell.timeSlice = nil
            }
        }
        return cell
    }
    
    @objc func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // We will make all of the cells be half the width of the collection view and 100% of the height
        let sectionInset = (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).sectionInset
        
        // So get the height & width of the view, take the insets into acount
        let availableWidth = collectionView.bounds.width - collectionView.contentInset.left - collectionView.contentInset.right - sectionInset.left - sectionInset.right
        let availableHeight = collectionView.bounds.height - collectionView.contentInset.top - collectionView.contentInset.bottom - sectionInset.top - sectionInset.bottom

        return CGSize(width: availableWidth / 2.0, height: availableHeight)
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

            timeSliceCollectionView?.reloadData()
        }
    }
    
    var index = 0
    var remain = 0.0
    let period = 1.0

    var timer:Timer?
    
    @IBOutlet weak var stageLabel: UILabel!
    @IBOutlet weak var remainingTimeLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var timeSliceCollectionView: UICollectionView!
    
}

