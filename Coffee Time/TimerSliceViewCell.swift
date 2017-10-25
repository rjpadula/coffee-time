//
//  TimerCollectionViewCell.swift
//  Coffee Time
//
//  Created by Robert J Padula on 10/19/17.
//  Copyright © 2017 Deep Dish Technology. All rights reserved.
//

import UIKit

class TimerSliceViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "timer cell"
    
    var timeSlice:TimeSlice? {
        didSet {
            if let timeSlice = timeSlice {
                label.text = timeSlice.label
            } else {
                label.text = "??"
            }
        }
    }
    
    @IBOutlet weak var label: UILabel!
}
