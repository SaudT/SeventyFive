//
//  HomeView.swift
//  SeventyFive
//
//  Created by Saud Tahir on 7/4/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        Image("HomeScreenLogo")
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .previewDevice("iPhone 14 Pro")
    }
}
 
