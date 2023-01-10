//
//  CoinMarketView.swift
//  nftApp
//
//  Created by Adam Reed on 1/7/23.
//

import SwiftUI

struct CoinMarketView: View {
    @StateObject private var vm = HomeViewModel()
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    withAnimation(.linear(duration: 2.0)) {
                        vm.reloadData()
                    }
                }, label: {
                    ZStack {
                        Rectangle()
                            .foregroundColor(Color.theme.background)
                            .frame(width: 100, height: 40, alignment: .bottom)
                            .padding(.horizontal)
                        HStack {
                            Text("Refresh")
                            Image(systemName: "goforward")
                                .foregroundColor(.white)
                                .rotationEffect(Angle(degrees: vm.isLoading ? 360 : 0), anchor: .center)
                        }
                    }
                })
            }
            .onAppear {
                print("all coins: \(vm.allCoins)")
            }
           
            columnTitlesSecondary
            allCoinsList
            
            if vm.storeManager.purchasedRemoveAds != true {
                AdMobBanner()
            }
        }
    }
}

struct CoinMarketView_Previews: PreviewProvider {
    static var previews: some View {
        CoinMarketView()
    }
}

extension CoinMarketView {
    private var allCoinsList: some View {
        List {
            ForEach(vm.allCoins) { coin in
                NavigationLink(destination: DetailView(coin: coin, userOwnsCoin: vm.portfolioCoins.contains(coin))) {
                    if (vm.portfolioCoins.contains(coin)) {
                        CoinRowView(coin: coin, userOwnsCoin: true)
                            .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 0))
                    } else {
                        CoinRowView(coin: coin, userOwnsCoin: false)
                            .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 0))
                    }
                }
            }
        }
        .listStyle(PlainListStyle())
    }
    
    
    private var columnTitlesSecondary: some View {
        HStack(spacing: 40) {
            HStack(spacing: 4) {
                Text("Coin")
                Image(systemName: "chevron.down")
                    .opacity((vm.sortOption == .rank || vm.sortOption == .rankReversed) ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: vm.sortOption == .rank ? 0 : 180))
            }
            .onTapGesture {
                withAnimation(.default) {
                    vm.sortOption = vm.sortOption == .rank ? .rankReversed : .rank
                }
            }
            
            Spacer()

            HStack(spacing: 4) {
                Text("All Time High / Low")
                Image(systemName: "chevron.down")
                    .opacity((vm.sortOption == .holdings || vm.sortOption == .holdingsReversed) ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: vm.sortOption == .holdings ? 0 : 180))
            }
            .onTapGesture {
                withAnimation(.default) {
                    vm.sortOption = vm.sortOption == .holdings ? .holdingsReversed : .holdings
                }
            }
            
            HStack(spacing: 4) {
                Text("Price")
                Image(systemName: "chevron.down")
                    .opacity((vm.sortOption == .price || vm.sortOption == .priceReversed) ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: vm.sortOption == .price ? 0 : 180))
            }
            .onTapGesture {
                withAnimation(.default) {
                    vm.sortOption = vm.sortOption == .price ? .priceReversed : .price
                }
            }
        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .padding(.horizontal)
    }
}
