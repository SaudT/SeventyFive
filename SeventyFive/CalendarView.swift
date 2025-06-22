import SwiftUI

struct CalendarView: View {
    @ObservedObject var challenge: Challenge
    private let calendar = Calendar.current
    private let daysInWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    @State private var selectedDate = Date()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("75 Hard Progress")
                .font(.title)
                .bold()
            
            // Month selector
            HStack {
                Button(action: { changeMonth(-1) }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.blue)
                }
                Text(monthYearString)
                    .font(.title2)
                    .bold()
                Button(action: { changeMonth(1) }) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal)
            
            // Days of week header
            HStack {
                ForEach(daysInWeek, id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal)
            
            // Calendar grid
            let weeks = getWeeksInMonth()
            VStack(spacing: 8) {
                ForEach(0..<weeks.count, id: \.self) { weekIndex in
                    HStack(spacing: 0) {
                        let week = weeks[weekIndex]
                        ForEach(0..<week.count, id: \.self) { dayIndex in
                            if let date = week[dayIndex] {
                                let dayData = getDayData(for: date)
                                DayCell(
                                    date: date,
                                    dayData: dayData,
                                    isToday: calendar.isDateInToday(date),
                                    isInChallengePeriod: isDateInChallengePeriod(date),
                                    isSelected: isSelectedDay(date),
                                    onTap: { selectDay(date) }
                                )
                            } else {
                                Spacer().frame(maxWidth: .infinity)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 2)
            
            // Legend
            VStack(spacing: 8) {
                HStack(spacing: 20) {
                    LegendItem(color: .green, text: "Completed")
                    LegendItem(color: .red, text: "Failed")
                }
                HStack(spacing: 20) {
                    LegendItem(color: .blue, text: "Today")
                    LegendItem(color: .purple, text: "Selected")
                }
            }
            .padding(.top)
            
            // Challenge info
            VStack(spacing: 4) {
                Text("Challenge started: \(formattedDate(challenge.startDate))")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                if let endDate = calendar.date(byAdding: .day, value: 74, to: challenge.startDate) {
                    Text("Challenge ends: \(formattedDate(endDate))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .onAppear {
            selectedDate = challenge.startDate
        }
    }
    
    private var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: selectedDate)
    }
    
    private func changeMonth(_ direction: Int) {
        if let newDate = calendar.date(byAdding: .month, value: direction, to: selectedDate) {
            selectedDate = newDate
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    // Returns an array of weeks, each week is an array of 7 optional Dates
    private func getWeeksInMonth() -> [[Date?]] {
        let month = calendar.component(.month, from: selectedDate)
        let year = calendar.component(.year, from: selectedDate)
        let firstDayOfMonth = calendar.date(from: DateComponents(year: year, month: month, day: 1))!
        let daysInMonth = calendar.range(of: .day, in: .month, for: firstDayOfMonth)!.count
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        
        var days: [Date?] = Array(repeating: nil, count: firstWeekday - 1)
        
        for day in 1...daysInMonth {
            if let date = calendar.date(from: DateComponents(year: year, month: month, day: day)) {
                days.append(date)
            }
        }
        
        while days.count % 7 != 0 {
            days.append(nil)
        }
        
        // Split into weeks
        var weeks: [[Date?]] = []
        for i in stride(from: 0, to: days.count, by: 7) {
            weeks.append(Array(days[i..<min(i+7, days.count)]))
        }
        return weeks
    }
    
    private func getDayData(for date: Date) -> ChallengeDay? {
        return challenge.getDayForDate(date)
    }
    
    private func isDateInChallengePeriod(_ date: Date) -> Bool {
        let challengeEnd = calendar.date(byAdding: .day, value: 74, to: challenge.startDate) ?? challenge.startDate
        return date >= challenge.startDate && date <= challengeEnd
    }
    
    private func isSelectedDay(_ date: Date) -> Bool {
        guard let currentDayDate = challenge.today.date else { return false }
        return calendar.isDate(date, inSameDayAs: currentDayDate)
    }
    
    private func selectDay(_ date: Date) {
        if let dayData = getDayData(for: date) {
            challenge.goToDay(dayData.id)
        }
    }
}

struct DayCell: View {
    let date: Date
    let dayData: ChallengeDay?
    let isToday: Bool
    let isInChallengePeriod: Bool
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                Circle()
                    .fill(backgroundColor)
                    .frame(width: 36, height: 36)
                
                if isToday {
                    Circle()
                        .stroke(Color.blue, lineWidth: 2)
                        .frame(width: 36, height: 36)
                }
                
                if isSelected {
                    Circle()
                        .stroke(Color.purple, lineWidth: 3)
                        .frame(width: 40, height: 40)
                }
                
                Text("\(Calendar.current.component(.day, from: date))")
                    .font(.system(size: 14, weight: isToday ? .bold : .regular))
                    .foregroundColor(textColor)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .frame(maxWidth: .infinity)
        .disabled(!isInChallengePeriod)
    }
    
    private var backgroundColor: Color {
        guard let dayData = dayData, isInChallengePeriod else {
            return .clear
        }
        
        if dayData.completedDate != nil {
            return .green
        } else if let dayDate = dayData.date, dayDate < Date() {
            return .red.opacity(0.7)
        } else {
            return .gray.opacity(0.3)
        }
    }
    
    private var textColor: Color {
        if !isInChallengePeriod {
            return .gray
        } else if dayData?.completedDate != nil {
            return .white
        } else {
            return .primary
        }
    }
}

struct LegendItem: View {
    let color: Color
    let text: String
    
    var body: some View {
        HStack {
            Circle()
                .fill(color)
                .frame(width: 12, height: 12)
            Text(text)
                .font(.caption)
        }
    }
}

struct CalenderView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 14 Pro")
    }
}
