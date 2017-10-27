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
    
    func complete() {
        remainingLabel.text = "Done"
    }
    
    func update(slice:TimeSlice) {
        remainingLabel.text = String(slice.remain)
    }
    
    var timeSlice:TimeSlice? {
        didSet {
            timeSlice?.cell = self
            if let timeSlice = timeSlice {
                label.text = timeSlice.label
                // call common function to set stuff that changes
                update(slice: timeSlice)

            } else {
                label.text = "??"
            }
        }
    }
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var remainingLabel: UILabel!
}
