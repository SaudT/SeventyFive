//
//  ChallengeStore.swift
//  SeventyFive
//
//  Created by Saud Tahir on 6/8/25.
//

import Foundation

class ChallengeStore: ObservableObject {
    @Published var challenge: Challenge

    private let saveKey = "challengeData"

    init() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode(Challenge.self, from: data) {
            self.challenge = decoded
        } else {
            self.challenge = Challenge()
        }
    }

    func save() {
        if let data = try? JSONEncoder().encode(challenge) {
            UserDefaults.standard.set(data, forKey: saveKey)
        }
    }

//    func reset() {
//        challenge.restart()
//        save()
//    }
}
