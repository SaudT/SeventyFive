//
//  ChallengeDay.swift
//  SeventyFive
//
//  Created by Saud Tahir on 6/8/25.
//

import Foundation

struct ChallengeDay: Identifiable, Codable, Equatable {
    let id: Int // 1-based day number
    var date: Date? // When this day was started/assigned
    var completedDate: Date? // When this day was completed
    var workout1: Bool = false
    var workout2Outdoor: Bool = false
    var diet: Bool = false
    var water: Bool = false
    var reading: Bool = false
    var progressPhoto: Bool = false
    
    var isComplete: Bool {
        workout1 && workout2Outdoor && diet && water && reading && progressPhoto
    }
    
    var wasCompletedOnTime: Bool {
        guard let date = date, let completedDate = completedDate else { return false }
        return Calendar.current.isDate(completedDate, inSameDayAs: date)
    }
}
