//
//  ChallengeDay.swift
//  SeventyFive
//
//  Created by Saud Tahir on 6/8/25.
//

import Foundation

struct ChallengeDay: Identifiable, Codable, Equatable{
    let id: Int // 1-based day number
    var workout1: Bool = false
    var workout2Outdoor: Bool = false
    var diet: Bool = false
    var water: Bool = false
    var reading: Bool = false
    var progressPhoto: Bool = false

    var isComplete: Bool {
        workout1 && workout2Outdoor && diet && water && reading && progressPhoto
    }
}
