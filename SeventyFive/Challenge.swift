//
//  Challenge.swift
//  SeventyFive
//
//  Created by Saud Tahir on 6/8/25.
//

import Foundation

class Challenge: ObservableObject, Codable {
    @Published var days: [String: ChallengeDay]
    @Published var streakCount: Int // 1-based index
    @Published var startDate: Date
    @Published var isActive: Bool
    @Published var percentage: Float
    @Published var currentDay: Date
    
    enum CodingKeys: CodingKey {
        case days, currentDay, startDate, isActive, percentage, streakCount
    }
    
    init() {
        
        let startDate = Date() // Create local variable first
        self.startDate = startDate
        self.days = [Self.todayDateStatic(): ChallengeDay(id: Self.todayDateStatic())]
        self.streakCount = 0
        self.isActive = true
        self.percentage = Float(1/75)
        self.currentDay = Date()
    }
    
    private static func todayDateStatic() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: Date())
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    private func todayDate() -> String{
        return formatDate(Date())
    }
    var today: ChallengeDay {
        return days[todayDate()] ?? ChallengeDay(id: todayDate())
    }
    
    var currentExpectedDay: Int {
        let daysSinceStart = Calendar.current.dateComponents([.day], from: startDate, to: Date()).day ?? 0
        return min(daysSinceStart + 1, 75)
    }
    
//    func markTask(_ keyPath: WritableKeyPath<ChallengeDay, Bool>, completed: Bool) {
//        days[formatDate(currentDay)][keyPath: keyPath] = completed
//
//        // If completing a task and day becomes complete, mark completion date
//        if completed && days[streakCount - 1].isComplete && days[streakCount - 1].completedDate == nil {
//            days[streakCount - 1].completedDate = Date()
//        }
//        // If unchecking and day is no longer complete, remove completion date
//        else if !completed && !days[streakCount - 1].isComplete {
//            days[streakCount - 1].completedDate = nil
//        }
//
//        objectWillChange.send()
//    }
    
    // Need to modify this func
    func advanceDay() {
        if streakCount < 75 && today.isComplete {
            streakCount += 1
        }
    }
    
    func goToDay(_ keyDate: String) {
        currentDay = days[keyDate]?.date ?? currentDay
    }
    
    // Need to modify this func
    func goToCurrentExpectedDay() {
        streakCount = currentExpectedDay
    }
    //Need to add logic to streakCount
    
    
    
//    func goToLastAccessibleDay() {
//        // Find the highest day that's been started or completed
//        for i in (1...75).reversed() {
//            if days[i-1].date != nil && days[i-1].date! <= Date() {
//                streakCount = i
//                return
//            }
//        }
//        streakCount = 1
//    }
    
//    func markDayComplete() {
//        if days[streakCount - 1].isComplete && days[streakCount - 1].completedDate == nil {
//            days[streakCount - 1].completedDate = Date()
//            objectWillChange.send()
//        }
//    }
    
//    func unmarkDayComplete() {
//        days[streakCount - 1].completedDate = nil
//        objectWillChange.send()
//    }
    
    func checkAndUpdateCurrentDay() {
        let expectedDay = currentExpectedDay
        if expectedDay > streakCount && !today.isComplete {
            // Missed a day - challenge should restart
            restart()
        } else if expectedDay > streakCount && today.isComplete {
            // Can advance to next day
            streakCount = expectedDay
        }
    }
    
    func restart() {
        self.startDate = Date()
        self.currentDay = Date()
        self.streakCount = 1
        self.isActive = true

        let todayKey = formatDate(currentDay)
        if days[todayKey] == nil {
            days[todayKey] = ChallengeDay(id: todayKey, date: currentDay)
        }

        self.percentage = Float(1.0 / 75.0)
    }

    func getDayForDate(_ date: Date) -> ChallengeDay? {
        return days.first { (_, day) in
            guard let dayDate = day.date else { return false }
            return Calendar.current.isDate(dayDate, inSameDayAs: date)
        }?.value
    }

    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        days = try container.decode([String: ChallengeDay].self, forKey: .days)
        streakCount = try container.decode(Int.self, forKey: .streakCount)
        startDate = try container.decode(Date.self, forKey: .startDate)
        isActive = try container.decodeIfPresent(Bool.self, forKey: .isActive) ?? true
        percentage = try container.decode(Float.self, forKey: .percentage)
        currentDay = try container.decode(Date.self, forKey: .currentDay)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(days, forKey: .days)
        try container.encode(streakCount, forKey: .streakCount)
        try container.encode(startDate, forKey: .startDate)
        try container.encode(isActive, forKey: .isActive)
        try container.encode(percentage, forKey: .percentage)
        try container.encode(currentDay, forKey: .currentDay)
    }
}
