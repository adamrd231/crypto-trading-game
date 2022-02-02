//
//  HomeView.swift
//  nftApp
//
//  Created by Adam Reed on 1/11/22.
//

import SwiftUI
import GoogleMobileAds

struct HomeView: View {
    
    @EnvironmentObject var vm: HomeViewModel
    @StateObject var storeManager: StoreManager
    
    @State var InterstitialAdCounter = 0 {
        didSet {
            if InterstitialAdCounter == 3 {
                showInterstittialAdvertising()
                InterstitialAdCounter = 0
            }
        }
    }
    
    // Interstitial object for Google Ad Mobs to play video advertising
    @State var interstitial: GADInterstitialAd?
    
    #if targetEnvironment(simulator)
        // Test Ad
        var googleBannerInterstitialAdID = "ca-app-pub-3940256099942544/1033173712"
    #else
        // Real Ad
        var googleBannerInterstitialAdID = "ca-app-pub-4186253562269967/5998934622"
    #endif
    
    private func showInterstittialAdvertising() {

        storeManager.showedAdvertising = true
        let request = GADRequest()
            GADInterstitialAd.load(
                withAdUnitID: googleBannerInterstitialAdID,
                request: request,
                completionHandler: { [self] ad, error in
                    // Check if there is an error
                    if let error = error {
                        return
                    }
                    // If no errors, create an ad and serve it
                    interstitial = ad
                    let root = UIApplication.shared.windows.first?.rootViewController
                    self.interstitial!.present(fromRootViewController: root!)

                    }
                )
    }
    
    

    
    // Control animation on main screen
    @State private var showPortfolio: Bool = false {
        didSet {
            if showPortfolio {
                vm.searchText = ""
            }
            InterstitialAdCounter += 1
            print(InterstitialAdCounter)
        }
    }

    // Sheet Navigation
    @State private var showPortfolioView: Bool = false // new sheet {}
    
    @State private var showSettingsView: Bool = false
    
    @State private var selectedCoin: CoinModel? = nil
    @State private var showDetailView: Bool = false
    
    @State var showNewGameScreen:Bool = false
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
                .sheet(isPresented: $showPortfolioView, content: {
                    
                    PortfolioView(showPortfolio: $showPortfolio).environmentObject(vm)
                    
                })
            
            VStack {
                homeHeader
                HomeStatsView(showPortfolio: $showPortfolio)
                if !showPortfolio {
                    SearchBarView(searchText: $vm.searchText)
                }
                
                columnTitles
                    
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
                .padding(.horizontal)
                
                if !showPortfolio {
                    allCoinsList
                    .transition(.move(edge: .leading))
                } else if showPortfolio {
                    portfolioCoinsList
                    .transition(.move(edge: .trailing))
                }
                
//                if showPortfolio {
//                    portfolioCoinsList
//                    .transition(.move(edge: .trailing))
//                }
                
                Button(action: {
                    showNewGameScreen.toggle()
                }) {
                    Text("Game Menu")
                        .font(.caption)
                        .padding(.top, 5)
                        .padding(.horizontal)
                }.padding()
                Spacer(minLength: 5)
                AdMobBanner()
                
            }
            .sheet(isPresented: $showSettingsView, content: {
                SettingsView()
            })
        }
        .sheet(isPresented: $showNewGameScreen, content: {
            NewGameScreen()
        })
        
        .background(
            VStack {
                NavigationLink(
                    destination: DetailLoadingView(coin: $selectedCoin),
                        isActive: $showDetailView,
                        label: { EmptyView()})
            }
        )
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView(storeManager: StoreManager())
                .navigationBarHidden(true)
                .environmentObject(dev.homeVM)
        }
    }
}

extension HomeView {
    private var homeHeader: some View {
        HStack {
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                .animation(.none)
                .onTapGesture {
                    if showPortfolio {
                        showPortfolioView.toggle()
                    } else {
                        showSettingsView.toggle()
                    }
                }
                .background(
                    CircleButtonAnimationView(animate: $showPortfolio)
                )
            Spacer()
            Text(showPortfolio ? "Portfolio" : "Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(Color.theme.accent)
                .animation(.none)
            Spacer()
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
                .onTapGesture {
                    withAnimation(.spring()) {
                        showPortfolio.toggle()
                        print("ShowPortfolio: \(showPortfolio)")
                    }
                }
        }
        .padding(.horizontal)
    }
    
    
    
    private var allCoinsList: some View {
        List {
            ForEach(vm.allCoins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: false)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 0))
                    .onTapGesture {
                        selectedCoin = coin
                        showDetailView.toggle()
                    }

                
            }
        }
        .listStyle(PlainListStyle())
    }
    
    private var portfolioCoinsList: some View {
        List {
            ForEach(vm.portfolioCoins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: true)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 0))
                    .onTapGesture {
                        selectedCoin = coin
                        showPortfolioView.toggle()
                }
            }
        }
        .listStyle(PlainListStyle())
    }
    
    private var columnTitles: some View {
        HStack {
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
            if showPortfolio {
                HStack(spacing: 4) {
                    Text("Holdings")
                    Image(systemName: "chevron.down")
                        .opacity((vm.sortOption == .holdings || vm.sortOption == .holdingsReversed) ? 1.0 : 0.0)
                        .rotationEffect(Angle(degrees: vm.sortOption == .holdings ? 0 : 180))
                }
                .onTapGesture {
                    withAnimation(.default) {
                        vm.sortOption = vm.sortOption == .holdings ? .holdingsReversed : .holdings
                    }
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
            .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
            
            
            Button(action: {
                withAnimation(.linear(duration: 2.0)) {
                    vm.reloadData()
                }
            }, label: {
                Image(systemName: "goforward")
            })
            .rotationEffect(Angle(degrees: vm.isLoading ? 360 : 0), anchor: .center)
        }
    }
    

}
