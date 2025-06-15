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

    enum CodingKeys: CodingKey {
        case days, currentDay
    }

    init() {
        self.days = (1...75).map { ChallengeDay(id: $0) }
        self.currentDay = 1
    }

    var today: ChallengeDay {
        days[currentDay - 1]
    }

    func markTask(_ keyPath: WritableKeyPath<ChallengeDay, Bool>, completed: Bool) {
        days[currentDay - 1][keyPath: keyPath] = completed
        objectWillChange.send()
    }

    func completeToday() -> Bool {
        today.isComplete
    }

    func advanceDay() {
        if currentDay < 75 {
            currentDay += 1
        }
    }

    func restart() {
        self.days = (1...75).map { ChallengeDay(id: $0) }
        self.currentDay = 1
    }

    // Codable conformance
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        days = try container.decode([ChallengeDay].self, forKey: .days)
        currentDay = try container.decode(Int.self, forKey: .currentDay)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(days, forKey: .days)
        try container.encode(currentDay, forKey: .currentDay)
    }
}
