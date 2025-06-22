//
//  Challenge.swift
//  SeventyFive
//
//  Created by Saud Tahir on 6/8/25.
//

import Foundation

class Challenge: ObservableObject, Codable {
    @Published var days: [ChallengeDay]
    @Published var currentDay: Int // 1-based index
    @Published var startDate: Date
    @Published var isActive: Bool
    
    enum CodingKeys: CodingKey {
        case days, currentDay, startDate, isActive
    }
    
    init() {
        let startDate = Date() // Create local variable first
        self.startDate = startDate
        self.days = (1...75).map { dayNumber in
            var day = ChallengeDay(id: dayNumber)
            day.date = Calendar.current.date(byAdding: .day, value: dayNumber - 1, to: startDate)
            return day
        }
        self.currentDay = 1
        self.isActive = true
    }
    
    var today: ChallengeDay {
        days[currentDay - 1]
    }
    
    var currentExpectedDay: Int {
        let daysSinceStart = Calendar.current.dateComponents([.day], from: startDate, to: Date()).day ?? 0
        return min(daysSinceStart + 1, 75)
    }
    
    func markTask(_ keyPath: WritableKeyPath<ChallengeDay, Bool>, completed: Bool) {
        days[currentDay - 1][keyPath: keyPath] = completed
        
        // If completing a task and day becomes complete, mark completion date
        if completed && days[currentDay - 1].isComplete && days[currentDay - 1].completedDate == nil {
            days[currentDay - 1].completedDate = Date()
        }
        // If unchecking and day is no longer complete, remove completion date
        else if !completed && !days[currentDay - 1].isComplete {
            days[currentDay - 1].completedDate = nil
        }
        
        objectWillChange.send()
    }
    
    func advanceDay() {
        if currentDay < 75 && today.isComplete {
            currentDay += 1
        }
    }
    
    func goToDay(_ dayNumber: Int) {
        if dayNumber >= 1 && dayNumber <= 75 {
            currentDay = dayNumber
        }
    }
    
    func goToCurrentExpectedDay() {
        currentDay = currentExpectedDay
    }
    
    func goToLastAccessibleDay() {
        // Find the highest day that's been started or completed
        for i in (1...75).reversed() {
            if days[i-1].date != nil && days[i-1].date! <= Date() {
                currentDay = i
                return
            }
        }
        currentDay = 1
    }
    
    func markDayComplete() {
        if days[currentDay - 1].isComplete && days[currentDay - 1].completedDate == nil {
            days[currentDay - 1].completedDate = Date()
            objectWillChange.send()
        }
    }
    
    func unmarkDayComplete() {
        days[currentDay - 1].completedDate = nil
        objectWillChange.send()
    }
    
    func checkAndUpdateCurrentDay() {
        let expectedDay = currentExpectedDay
        if expectedDay > currentDay && !today.isComplete {
            // Missed a day - challenge should restart
            restart()
        } else if expectedDay > currentDay && today.isComplete {
            // Can advance to next day
            currentDay = expectedDay
        }
    }
    
    func restart() {
        self.startDate = Date()
        self.days = (1...75).map { dayNumber in
            var day = ChallengeDay(id: dayNumber)
            day.date = Calendar.current.date(byAdding: .day, value: dayNumber - 1, to: startDate)
            return day
        }
        self.currentDay = 1
        self.isActive = true
    }
    
    func getDayForDate(_ date: Date) -> ChallengeDay? {
        return days.first { day in
            guard let dayDate = day.date else { return false }
            return Calendar.current.isDate(dayDate, inSameDayAs: date)
        }
    }
    
    // Codable conformance
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        days = try container.decode([ChallengeDay].self, forKey: .days)
        currentDay = try container.decode(Int.self, forKey: .currentDay)
        startDate = try container.decode(Date.self, forKey: .startDate)
        isActive = try container.decodeIfPresent(Bool.self, forKey: .isActive) ?? true
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(days, forKey: .days)
        try container.encode(currentDay, forKey: .currentDay)
        try container.encode(startDate, forKey: .startDate)
        try container.encode(isActive, forKey: .isActive)
    }
}
