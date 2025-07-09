//
//  ChecklistView.swift
//  SeventyFive
//
//  Created by Saud Tahir on 6/8/25.
//

import SwiftUI

struct ChecklistView: View {
    @ObservedObject var challenge: Challenge
    
    var body: some View {
        VStack(alignment: .center, spacing: 24) {
            // Day Navigation Header
            HStack {
                Button(action: {
                    if let prevDay = Calendar.current.date(byAdding: .day, value: -1, to: challenge.currentDay) {
                        challenge.currentDay = prevDay
                    }
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                }
                
                Spacer()
                
                VStack(spacing: 4) {
                   
                    Text(formatDate(challenge.currentDay))
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
                
                Spacer()

                // Increment by 1 day
                Button(action: {
                    if let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: challenge.currentDay) {
                        challenge.currentDay = nextDay
                    }
                }) {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                }
            }
            .padding(.bottom, 8)
            
            VStack(spacing: 16) {
                ChecklistItem(title: "45-min Workout (anywhere)", isCompleted: binding(for: \.workout1))
                ChecklistItem(title: "45-min Workout (outdoors)", isCompleted: binding(for: \.workout2Outdoor))
                ChecklistItem(title: "Follow Diet", isCompleted: binding(for: \.diet))
                ChecklistItem(title: "Drink 1 Gallon Water", isCompleted: binding(for: \.water))
                ChecklistItem(title: "Read 10 Pages (non-fiction)", isCompleted: binding(for: \.reading))
                ChecklistItem(title: "Take Progress Photo", isCompleted: binding(for: \.progressPhoto))
            }
            
            .padding(.vertical, 8)
            
            // Action Buttons
//            VStack(spacing: 12) {
//                if day.isComplete && day.completedDate == nil {
//                    Button("Mark Day Complete") {
//                        challenge.markDayComplete()
//                    }
//                    .buttonStyle(.borderedProminent)
//                    .frame(maxWidth: .infinity)
//                } else if day.completedDate != nil {
//                    Button("Unmark Completion") {
//                        challenge.unmarkDayComplete()
//                    }
//                    .buttonStyle(.bordered)
//                    .frame(maxWidth: .infinity)
//                }
//
//                // Quick day jumper
//                HStack(spacing: 8) {
//                    Button("Today") {
//                        challenge.goToCurrentExpectedDay()
//                    }
//                    .buttonStyle(.bordered)
//                    .font(.caption)
//
//                    Button("Day 1") {
//                        challenge.goToDay(1)
//                    }
//                    .buttonStyle(.bordered)
//                    .font(.caption)
//
//                    Button("Last Day") {
//                        challenge.goToLastAccessibleDay()
//                    }
//                    .buttonStyle(.bordered)
//                    .font(.caption)
//                }
//            }
//            .padding(.top, 16)
        }
        .padding()
        .cornerRadius(12)
        .shadow(radius: 2)
    }
    
    private func binding(for keyPath: WritableKeyPath<ChallengeDay, Bool>) -> Binding<Bool> {
        Binding<Bool>(
            get: {
                let key = formatDate(challenge.currentDay)
                return challenge.days[key]?[keyPath: keyPath] ?? false
            },
            set: { newValue in
                let key = formatDate(challenge.currentDay)
                if var day = challenge.days[key] {
                    day[keyPath: keyPath] = newValue
                    challenge.days[key] = day
                    challenge.objectWillChange.send() // Manually notify since dictionary mutation may not trigger updates
                } else {
                    var newDay = ChallengeDay(id: key)
                    newDay[keyPath: keyPath] = newValue
                    challenge.days[key] = newDay
                    challenge.objectWillChange.send()
                }
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
        .cornerRadius(8)
    }
}



struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ChecklistView(challenge: ChallengeStore().challenge)
            .previewDevice("iPhone 14 Pro")
    }
}

