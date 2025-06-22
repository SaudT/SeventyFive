//
//  ProgressView.swift
//  SeventyFive
//
//  Created by Saud Tahir on 6/8/25.
//

import Foundation
import SwiftUI

struct ProgressView75: View {
    @ObservedObject var challenge: Challenge

    var body: some View {
        VStack {
            HStack {
                ForEach(0..<75, id: \.self) { i in
                    Circle()
                        .frame(width: 6, height: 6)
                        .foregroundColor(i < challenge.currentDay - 1 ? .green : .gray.opacity(0.3))
                }
            }
            .padding(.vertical, 8)
            Text("Day \(challenge.currentDay) of 75")
                .font(.subheadline)
        }
        .padding(.horizontal)
    }
}



