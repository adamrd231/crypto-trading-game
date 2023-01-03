//
//  WelcomeScreen.swift
//  nftApp
//
//  Created by Adam Reed on 12/29/22.
//

import SwiftUI

struct WelcomeScreen: View {
    
    @StateObject private var vm = HomeViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Crypto Stand")
                .font(.largeTitle)
                .fontWeight(.heavy)
            ForEach(vm.FAQs, id: \.title) { item in
                VStack(alignment: .leading) {
                    Text(item.title)
                        .font(.title3)
                        .fontWeight(.bold)
                    Text(item.body)
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width * 0.8)
    }
}


