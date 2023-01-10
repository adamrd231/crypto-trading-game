//
//  UserPortfolioOverview.swift
//  nftApp
//
//  Created by Adam Reed on 1/3/23.
//

import SwiftUI

struct UserPortfolioOverview: View {
    @EnvironmentObject var vm: HomeViewModel
    
    @State var showWelcomeScreen: Bool = false
    @State var searchText: String = ""
    
    var body: some View {
        ZStack {
            Color.theme.accent
                .ignoresSafeArea()
                
            VStack {
                // Header
                VStack {
                    HStack {
                        HStack(spacing: 5) {
                            Text("Crypto Stand")
                            Text("V\(Bundle.main.releaseVersionNumber ?? "V1.0")")
                        }
                        .font(.caption)
                        .foregroundColor(Color.theme.secondaryText)
                        
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
                .padding()
                .foregroundColor(.white)
                
                TitleColumns().environmentObject(vm)
                    .padding()
                // Coins Portfolio
                ScrollView {
                    if vm.portfolioCoins.count > 0 {
                        ForEach(vm.portfolioCoins) { coin in
                            CoinView(coin: coin)
                        }
                    } else {
                        Text("Buy Coins in the market")
                            .fontWeight(.bold)
                            .padding()
                    }
                }
                .frame(width: UIScreen.main.bounds.width)
                .background(Color.theme.background)
            }
        }
        .sheet(isPresented: $showWelcomeScreen) {
            WelcomeScreen()
        }
    }
}

struct UserPortfolioOverview_Previews: PreviewProvider {
    static var previews: some View {
        UserPortfolioOverview(searchText: "Hello")
            .environmentObject(dev.homeVM)
    }
}
