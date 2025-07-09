//
//  StreakView.swift
//  SeventyFive
//
//  Created by Saud Tahir on 7/4/25.
//

import SwiftUI

struct StreakView: View {
    @ObservedObject var challenge: Challenge
    var body: some View {
        VStack{
            ProgressView(value: challenge.percentage)
                .padding()
            Text("Day \(challenge.streakCount) of 75")
                .font(.title3)
                .bold()
                .padding(.top, -10)
//            Button("More"){
//                challenge.percentage += Float(0.1)
//            }
        }
    }
}

struct StreakView_Previews: PreviewProvider {
    static var previews: some View {
        StreakView(challenge: ChallengeStore().challenge)
            .previewDevice("iPhone 14 Pro")
    }
}
