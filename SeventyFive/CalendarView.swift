import SwiftUI

struct CalendarView: View {
    @ObservedObject var challenge: Challenge
    private let calendar = Calendar.current
    private let daysInWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("75 Hard Progress")
                .font(.title)
                .bold()
            
            // Month selector (static for now)
            HStack {
                Button(action: {}) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.blue)
                }
                Text("March 2024")
                    .font(.title2)
                    .bold()
                Button(action: {}) {
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
            
            // Calendar grid with simple bubbles
            let weeks = getWeeksInMonth()
            VStack(spacing: 8) {
                ForEach(0..<weeks.count, id: \.self) { weekIndex in
                    HStack(spacing: 0) {
                        let week = weeks[weekIndex]
                        ForEach(0..<week.count, id: \.self) { dayIndex in
                            if let date = week[dayIndex] {
                                let isCompleted = isDayCompleted(date)
                                DayCell(date: date, isCompleted: isCompleted)
                            } else {
                                Spacer().frame(maxWidth: .infinity)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 2)
            
            // Legend
            HStack(spacing: 20) {
                LegendItem(color: .blue, text: "Completed")
                LegendItem(color: .gray, text: "Not Started")
            }
            .padding(.top)
        }
        .padding()
    }
    
    // Returns an array of weeks, each week is an array of 7 optional Dates
    private func getWeeksInMonth() -> [[Date?]] {
        let today = Date()
        let month = calendar.component(.month, from: today)
        let year = calendar.component(.year, from: today)
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
    
    private func isDayCompleted(_ date: Date) -> Bool {
        // TODO: Implement actual completion check based on challenge data
        // For demo, mark every 2nd and 3rd day as completed
        let day = calendar.component(.day, from: date)
        return day % 2 == 0 || day % 3 == 0
    }
}

struct DayCell: View {
    let date: Date
    let isCompleted: Bool
    
    var body: some View {
        Text("\(Calendar.current.component(.day, from: date))")
            .frame(width: 36, height: 36)
            .background(isCompleted ? Color.blue : Color.clear)
            .foregroundColor(isCompleted ? .white : .gray)
            .clipShape(Circle())
            .frame(maxWidth: .infinity)
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
