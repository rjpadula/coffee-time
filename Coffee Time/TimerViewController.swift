//
//  FirstViewController.swift
//  Coffee Time
//
//  Created by Robert J Padula on 9/8/17.
//  Copyright © 2017 Deep Dish Technology. All rights reserved.
//

import UIKit
import UserNotifications

class TimerViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadJSONfiles()
        
        timerSet = timerSets.first
        remainingTimeLabel.text = "Press Start"
        
        timeSliceCollectionView.dataSource = self
        timeSliceCollectionView.delegate = self
        
        // Need to request permission for local notifications
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadJSONfiles() {
        if let files = Bundle.main.urls(forResourcesWithExtension: "json", subdirectory: nil) {
            timerSets = files.flatMap { (url:URL) -> TimerSet in
                let data = try! Data(contentsOf: url)
                let jsonDecoder = JSONDecoder()
                let set = try! jsonDecoder.decode(TimerSet.self, from: data)
                return set
            }
        }
    }
    @IBAction func startPressed(_ sender: Any) {
        if (timer != nil) {
            // We are already running - deal with this later
            
        } else {
            guard let timerSet = timerSet else {
                return
            }
            // Set up all of the notifications
            var totalTime = 0.0
            var notificationIDs = [String]()
            for slice in timerSet.slices {
                // Add notification for start sound, if it has one
                if let sound = slice.startSound {
                    let id = addLocalNotification(title: timerSet.label, text: slice.label, sound: sound, when: totalTime)
                    notificationIDs.append(id)
                }
                // Need to keep running total
                totalTime += slice.duration
            }
            
            // Start the timer
            index = timerSet.slices.startIndex
            timer = Timer.scheduledTimer(timeInterval: period, target: self, selector: #selector(timerTick), userInfo: nil, repeats: true)
        }
    }
    
    func addLocalNotification(title:String, text:String, sound:String, when:TimeInterval) -> String {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = text
        
        // Deliver the notification in five seconds.
        content.sound = UNNotificationSound(named: sound)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: when, repeats: false)
        
        // Schedule the notification.
        let request = UNNotificationRequest(identifier: text, content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request, withCompletionHandler: nil)
        
        NSLog("Adding notitication \(request.identifier)")

        return text
    }
    @IBAction func timerTick(_ timer:Timer) {
        guard let timerSet = timerSet else {
            return
        }
        // How long ?
        let slice = timerSet.slices[index]
        slice.remain -= period
        if slice.remain <= 0.0 {
            // End of the time period!
            slice.cell?.complete()
            index += 1
            if index == timerSet.slices.endIndex {
                // That's the total end of everything!
                stageLabel.text = "Done"
                timer.invalidate()
                self.timer = nil
            } else {
                // On to the next period
                stageLabel.text = timerSet.slices[index].label
                
                timeSliceCollectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: .centeredHorizontally, animated: true)
            }
        } else {
            slice.cell?.update(slice: slice)
        }
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
        return timerSet?.slices.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = timeSliceCollectionView.dequeueReusableCell(withReuseIdentifier: TimerSliceViewCell.reuseIdentifier, for: indexPath)
        if let cell = cell as? TimerSliceViewCell {
            cell.timeSlice = timerSet?.slices[indexPath.row]
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
                
                for slice in timerSet.slices {
                    slice.reset()
                }
            } else {
                startButton.isEnabled = false
            }
            timeSliceCollectionView?.reloadData()
        }
    }
    
    var index = 0
    let period = 1.0

    var timer:Timer?
    
    @IBOutlet weak var stageLabel: UILabel!
    @IBOutlet weak var remainingTimeLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var timeSliceCollectionView: UICollectionView!
    
}

