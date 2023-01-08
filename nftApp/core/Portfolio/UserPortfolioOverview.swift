//
//  UserPortfolioOverview.swift
//  nftApp
//
//  Created by Adam Reed on 1/3/23.
//

import SwiftUI

struct UserPortfolioOverview: View {
    @State var vm = HomeViewModel()
    @State var showWelcomeScreen: Bool = false
    
    // Grid spacing variable
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        VStack {
            // Header
            VStack {
                HStack {
                    HStack(spacing: 5) {
                        Text("Crypto Stand")
                            .fontWeight(.bold)
                        Text("V\(Bundle.main.releaseVersionNumber ?? "V1.0")")
                            .fontWeight(.bold)
                    }
                    Spacer()
                    Button {
                        showWelcomeScreen = true
                    } label: {
                        Text("?")
                            .fontWeight(.heavy)
                    }
                }
                .padding(.vertical)
                .font(.callout)
                .foregroundColor(Color.gray)
                
                VStack(spacing: 10) {
                    PortfolioStatDouble(title: "Money", stat: vm.storeManager.game.gameDollars)
                    PortfolioStatePercentage(title: "Daily Change", value: vm.Portfolio24Change)
                }
            }
            .background(Color.theme.blue)
            
            
            // Coins Portfolio
            ScrollView {
                if vm.allCoins.count > 0 {
                    LazyVGrid(
                        columns: columns,
                        alignment: .center,
                        spacing: 10,
                        pinnedViews: [],
                        content: {
                            CoinPortfolioView(vm: vm)
                    })
                }
            }
        }
        .sheet(isPresented: $showWelcomeScreen) {
            WelcomeScreen()
        }
    }
}

struct UserPortfolioOverview_Previews: PreviewProvider {
    static var previews: some View {
        UserPortfolioOverview()
    }
}
