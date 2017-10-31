//
//  TimerSet.swift
//  Coffee Time
//
//  Created by Robert J Padula on 10/14/17.
//  Copyright © 2017 Deep Dish Technology. All rights reserved.
//

import Foundation

class TimerSet : Decodable {
   
    enum CodingKeys: String, CodingKey {
        case slices = "times"
        case label
    }
    
    let label : String
    let slices : [TimeSlice]
}
