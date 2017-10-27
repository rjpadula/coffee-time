//
//  TimeSlice.swift
//  Coffee Time
//
//  Created by Robert J Padula on 10/14/17.
//  Copyright © 2017 Deep Dish Technology. All rights reserved.
//

import Foundation

class TimeSlice {
    init(label:String, duration:TimeInterval) {
        self.label = label
        self.duration = duration

        reset()
    }
    /// reset to re-run the timer
    func reset() {
        remain = duration
    }
    // initializer for loading from a json file
    convenience init?(json:NSDictionary) {
        // JSON must provide the label and the duration
        guard let label = json["label"] as? String, let duration = json["duration"] as? NSNumber else {
            NSLog("Bad data in \(json.debugDescription)")
            return nil
        }
        // call the real initializer
        self.init(label: label, duration: duration.doubleValue)
        // We can add optional values here
    }
    let duration:TimeInterval
    let label:String
    
    
    /// These change as the timer runs
    var remain:TimeInterval = 0.0
    weak var cell:TimerSliceViewCell?
}
