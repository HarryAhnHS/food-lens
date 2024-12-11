//
//  Date++.swift
//  FoodLens
//
//  Created by Harry Ahn on 10/12/2024.
//

import Foundation

extension Date {
    func timeAgoDisplay() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour

        if secondsAgo < minute {
            return "just now"
        } else if secondsAgo < hour {
            return "\(secondsAgo / minute) min ago"
        } else if secondsAgo < day {
            return "\(secondsAgo / hour) hours ago"
        } else {
            return "\(secondsAgo / day) days ago"
        }
    }
}
