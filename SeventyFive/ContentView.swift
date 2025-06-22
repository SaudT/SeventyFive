//
//  ContentView.swift
//  SeventyFive
//
//  Created by Saud Tahir on 6/8/25.
//

import SwiftUI

import SwiftUI

struct ContentView: View {
    @StateObject var store = ChallengeStore()
    @State private var showRestartAlert = false
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Checklist Tab
            NavigationStack {
                VStack(spacing: 24) {
//                    ProgressView75(challenge: store.challenge)
//                        .padding(.horizontal)

                    ChecklistView(challenge: store.challenge, showRestartAlert: $showRestartAlert)
                        .padding(.horizontal)
                    
                    Spacer()
                    
//                    Button("Restart Challenge") {
//                        showRestartAlert = true
//                    }
//                    .foregroundColor(.red)
//                    .padding()
//                    .frame(maxWidth: .infinity)
//                    .background(Color.red.opacity(0.1))
//                    .cornerRadius(10)
//                    .padding(.horizontal)
//                    .padding(.bottom, 32)
                }
//                .navigationTitle("75 Hard")
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
        .onChange(of: store.challenge.currentDay) { _ in
            store.save()
        }
        .onChange(of: store.challenge.days) { _ in
            store.save()
        }
        .onAppear {
            store.challenge.checkAndUpdateCurrentDay()
        }
//        .alert(isPresented: $showRestartAlert) {
//            Alert(
//                title: Text("Restart Challenge?"),
//                message: Text("Are you sure you want to restart from Day 1?"),
//                primaryButton: .destructive(Text("Restart")) {
//                    store.reset()
//                },
//                secondaryButton: .cancel()
//            )
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 14 Pro")
    }
}
