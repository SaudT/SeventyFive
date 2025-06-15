//
//  ChecklistView.swift
//  SeventyFive
//
//  Created by Saud Tahir on 6/8/25.
//

import SwiftUI

struct ChecklistView: View {
    @ObservedObject var challenge: Challenge
    @Binding var showRestartAlert: Bool

    var body: some View {
        let day = challenge.today
        VStack(alignment: .center, spacing: 24) {
            Text("Day \(challenge.currentDay) Checklist")
                .font(.title2)
                .bold()
                .padding(.bottom, 8)
            
            VStack(spacing: 16) {
                ChecklistItem(title: "45-min Workout (anywhere)", isCompleted: binding(for: \.workout1))
                ChecklistItem(title: "45-min Workout (outdoors)", isCompleted: binding(for: \.workout2Outdoor))
                ChecklistItem(title: "Follow Diet (no cheat/alcohol)", isCompleted: binding(for: \.diet))
                ChecklistItem(title: "Drink 1 Gallon Water", isCompleted: binding(for: \.water))
                ChecklistItem(title: "Read 10 Pages (non-fiction)", isCompleted: binding(for: \.reading))
                ChecklistItem(title: "Take Progress Photo", isCompleted: binding(for: \.progressPhoto))
            }
            .padding(.vertical, 8)

            if day.isComplete {
                Button("Complete Day") {
                    challenge.advanceDay()
                }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity)
                .padding(.top, 16)
            }
        }
        .padding()
        // .background(Color(uiColor: .systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
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

struct ChecklistItem: View {
    let title: String
    @Binding var isCompleted: Bool
    
    var body: some View {
        Button(action: {
            isCompleted.toggle()
        }) {
            HStack(spacing: 12) {
                Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isCompleted ? .green : .gray)
                    .font(.title3)
                
                Text(title)
                    .font(.body)
                    .foregroundColor(.primary)
                    .strikethrough(isCompleted)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.vertical, 8)
    }
}
