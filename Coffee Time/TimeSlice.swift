//
//  TimeSlice.swift
//  Coffee Time
//
//  Created by Robert J Padula on 10/14/17.
//  Copyright © 2017 Deep Dish Technology. All rights reserved.
//

import Foundation

class TimeSlice : Decodable {
    /// reset to re-run the timer
    func reset() {
        remain = duration
    }

    let duration:Double
    let label:String
    
    enum CodingKeys: String, CodingKey {
        case duration
        case label
    }
    
    /// These change as the timer runs
    var remain:TimeInterval = 0.0
    weak var cell:TimerSliceViewCell? = nil
}

