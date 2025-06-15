//
//  ChecklistView.swift
//  SeventyFive
//
//  Created by Saud Tahir on 6/8/25.
//

import Foundation
import SwiftUI

struct ChecklistView: View {
    @ObservedObject var challenge: Challenge
    @Binding var showRestartAlert: Bool

    var body: some View {
        let day = challenge.today
        VStack(alignment: .leading, spacing: 20) {
            Text("Day \(challenge.currentDay) Checklist")
                .font(.title2)
                .bold()
            Toggle("45-min Workout (anywhere)", isOn: binding(for: \.workout1))
            Toggle("45-min Workout (outdoors)", isOn: binding(for: \.workout2Outdoor))
            Toggle("Follow Diet (no cheat/alcohol)", isOn: binding(for: \.diet))
            Toggle("Drink 1 Gallon Water", isOn: binding(for: \.water))
            Toggle("Read 10 Pages (non-fiction)", isOn: binding(for: \.reading))
            Toggle("Take Progress Photo", isOn: binding(for: \.progressPhoto))

            if day.isComplete {
                Button("Complete Day") {
                    challenge.advanceDay()
                }
                .buttonStyle(.borderedProminent)
                .padding(.top)
            }
        }
        .padding()
        .alert(isPresented: $showRestartAlert) {
            Alert(
                title: Text("Restart Challenge?"),
                message: Text("You missed a day. Restart from Day 1?"),
                primaryButton: .destructive(Text("Restart")) {
                    challenge.restart()
                },
                secondaryButton: .cancel()
            )
        }
    }

    private func binding(for keyPath: WritableKeyPath<ChallengeDay, Bool>) -> Binding<Bool> {
        Binding(
            get: { challenge.days[challenge.currentDay - 1][keyPath: keyPath] },
            set: { newValue in
                challenge.markTask(keyPath, completed: newValue)
            }
        )
    }
}
