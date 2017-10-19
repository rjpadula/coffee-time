//
//  TimerSet.swift
//  Coffee Time
//
//  Created by Robert J Padula on 10/14/17.
//  Copyright © 2017 Deep Dish Technology. All rights reserved.
//

import Foundation

class TimerSet {
    
    init?(url:URL) {
        guard let stream = InputStream.init(url: url) else
        {
            NSLog("Failed to open stream for \(url)")
            return nil
        }
        // 2. Open it
        stream.open()
        // 3. Slurp the data up
        guard let json = try? JSONSerialization.jsonObject(with: stream, options: .allowFragments) else {
            NSLog("Failed to parse json for \(url)")
            return nil
        }
        // We expect the stream to be a dictionary, so check that
        guard let dict = json as? NSDictionary else
        {
            NSLog("Failed to get dictionary for \(url)")
            return nil
        }
        if let label = dict["label"] as? String {
            self.label = label
        }
        if let sliceArray = dict["times"] as? NSArray {
            for case let sliceJSON as NSDictionary in sliceArray {
                // This kinda skips problems, need to fix that
                guard let timeSlice = TimeSlice(json:sliceJSON) else {
                    continue
                }
                // If we add optional stuff to time slice, get it and set it here
                slices.append(timeSlice)
            }
        }
        if slices.isEmpty {
            NSLog("No slices for \(url)")
            return nil
        }
    }
    private(set) var label  = ""
    private(set) var slices = [TimeSlice]()
}
