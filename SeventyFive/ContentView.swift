//
//  ContentView.swift
//  SeventyFive
//
//  Created by Saud Tahir on 6/8/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var store = ChallengeStore()
//    @State private var showRestartAlert = false
    @State private var selectedTab = 0
    @State var launchScreen = false
    
    var body: some View {
        Group {
            if launchScreen{
                VStack{
                    HomeView()
                    StreakView(challenge: store.challenge)
                    Spacer()
                }
            }
            else{
                TabView(selection: $selectedTab) {
                    // Checklist Tab
                    NavigationStack {
                        VStack(spacing: 24) {
                            ChecklistView(challenge: store.challenge)
                                .padding(.horizontal)
                            Spacer()
                            StreakView(challenge: store.challenge)
                                .padding(.bottom, 20.0)
                        }
                    }
                    .tabItem {
                        Label("Checklist", systemImage: "checklist")
                    }
                    .tag(0)
                    
                    // Calendar Tab
                    NavigationStack {
                        CalendarView(challenge: store.challenge)
                        //                    .navigationTitle("Calendar")
                    }
                    .tabItem {
                        Label("Calendar", systemImage: "calendar")
                    }
                    .tag(1)
                }
                .onChange(of: store.challenge.streakCount) { _ in
                    store.save()
                }
                .onChange(of: store.challenge.days) { _ in
                    store.save()
                }
                .onAppear {
                    store.challenge.checkAndUpdateCurrentDay()
                }
            }
        }
        .onAppear() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                launchScreen = false
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 14 Pro")
    }
}
