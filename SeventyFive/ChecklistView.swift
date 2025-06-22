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
            // Day Navigation Header
            HStack {
                Button(action: {
                    challenge.goToDay(challenge.currentDay - 1)
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(challenge.currentDay > 1 ? .blue : .gray)
                        .font(.title2)
                }
                .disabled(challenge.currentDay <= 1)
                
                Spacer()
                
                VStack(spacing: 4) {
                    Text("Day \(challenge.currentDay) of 75")
                        .font(.title2)
                        .bold()
                    
                    if let dayDate = day.date {
                        Text(formatDate(dayDate))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    if day.completedDate != nil {
                        HStack(spacing: 4) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .font(.caption)
                            Text("Completed")
                                .font(.caption)
                                .foregroundColor(.green)
                        }
                    }
                }
                
                Spacer()
                
                Button(action: {
                    challenge.goToDay(challenge.currentDay + 1)
                }) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(challenge.currentDay < 75 ? .blue : .gray)
                        .font(.title2)
                }
                .disabled(challenge.currentDay >= 75)
            }
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
            
            // Action Buttons
            VStack(spacing: 12) {
                if day.isComplete && day.completedDate == nil {
                    Button("Mark Day Complete") {
                        challenge.markDayComplete()
                    }
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)
                } else if day.completedDate != nil {
                    Button("Unmark Completion") {
                        challenge.unmarkDayComplete()
                    }
                    .buttonStyle(.bordered)
                    .frame(maxWidth: .infinity)
                }
                
                // Quick day jumper
                HStack(spacing: 8) {
                    Button("Today") {
                        challenge.goToCurrentExpectedDay()
                    }
                    .buttonStyle(.bordered)
                    .font(.caption)
                    
                    Button("Day 1") {
                        challenge.goToDay(1)
                    }
                    .buttonStyle(.bordered)
                    .font(.caption)
                    
                    Button("Last Day") {
                        challenge.goToLastAccessibleDay()
                    }
                    .buttonStyle(.bordered)
                    .font(.caption)
                }
            }
            .padding(.top, 16)
        }
        .padding()
//        .background(Color(uiColor: .systemBackground))
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
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
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
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
//        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(8)
    }
}



struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 14 Pro")
    }
}

