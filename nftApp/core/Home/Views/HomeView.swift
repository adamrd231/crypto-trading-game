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
    @State private var selectedCoin: CoinModel? = nil
    @StateObject var storeManager: StoreManager
    

    // Control animation on main screen
    @State private var showPortfolio: Bool = false {
        didSet {
            if showPortfolio {
                vm.searchText = ""
            }
            if storeManager.purchasedRemoveAds != true {
                InterstitialAdCounter += 1
                print(InterstitialAdCounter)
            }
            
        }
    }

    // Sheet Navigation
    @State private var showDetailView: Bool = false
    @State var showPortfolioView: Bool = false
    
    @State var InterstitialAdCounter = 0 {
        didSet {
            if InterstitialAdCounter >= 5 {
                if storeManager.purchasedRemoveAds != true {
                    loadInterstitialAd()
                    InterstitialAdCounter = 0

                }
            }
        }
    }
    
    @State var interstitial: GADInterstitialAd?

    #if targetEnvironment(simulator)
        // Test Ad
        var googleBannerInterstitialAdID = "ca-app-pub-3940256099942544/1033173712"
    #else
        // Real Ad
        var googleBannerInterstitialAdID = "ca-app-pub-4186253562269967/5364863972"
    #endif
    
    // App Tracking Transparency - Request permission and play ads on open only
    private func loadInterstitialAd() {

        // Tracking authorization completed. Start loading ads here.
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

                    self.interstitial?.present(fromRootViewController: root!)

                    

                    }
                )
      }
    
    // MARK: Main Body
    // -------------------
    var body: some View {
        TabView {
            // First Screen
            homeView
                .sheet(isPresented: $showPortfolioView, content: {
                    PortfolioView(storeManager: storeManager, showPortfolio: $showPortfolioView)
                })
                .tabItem { VStack {
                    Image(systemName: "bitcoinsign.circle")
                    Text("Market")
                }}
            
            // Information on the game
            SettingsView()
                .tabItem { VStack {
                    Image(systemName: "info.circle")
                    Text("About")
                }}
            
            // Game Options Screen
            NewGameScreen()
                .tabItem { VStack {
                    Image(systemName: "gamecontroller")
                    Text("Options")
                }}
            
            // In App Purchases Screen
            InAppStorePurchasesView(storeManager: storeManager)
                .tabItem { VStack {
                    Image(systemName: "creditcard")
                    Text("Remove Ads")
                }}
        }
    }
        
}


// MARK: Previews
// -------------------
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView(storeManager: StoreManager())
                .navigationBarHidden(true)
                .environmentObject(dev.homeVM)
        }
    }
}


// MARK: Extension to HomeView
// ----------------------------
extension HomeView {
    private var homeView: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            
            VStack {
                homeHeader
                HomeStatsView(showPortfolio: $showPortfolio)
                if !showPortfolio {
                    SearchBarView(searchText: $vm.searchText)
                }
                
                columnTitles
                    
                if !showPortfolio {
                    allCoinsList
                    .transition(.move(edge: .leading))
                } else if showPortfolio {
                    portfolioCoinsList
                    .transition(.move(edge: .trailing))
                }
                   
                Spacer(minLength: 5)
                if storeManager.purchasedRemoveAds != true {
                    AdMobBanner()
                }
               
            }

            .background(
                VStack {
                    NavigationLink(
                        destination: DetailLoadingView(coin: $selectedCoin),
                            isActive: $showDetailView,
                            label: { EmptyView()})
                }
            )
            .navigationBarHidden(true)
        }
    }
    
  
    private var homeHeader: some View {
        HStack {
            
            // Left Circle button - manages bringing up portfolio to buy coins and information about the app
            CircleButtonView(iconName: "plus")
                .animation(.none)
                .onTapGesture {
                    showPortfolioView.toggle()
                
                }
                .background(
                    CircleButtonAnimationView(animate: $showPortfolio)
                )
            Spacer()
            
            //  Center Description Text
            Text(showPortfolio ? "Portfolio" : "Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(Color.theme.accent)
                .animation(.none)
            Spacer()
            
            // Right Circle Button - handles moving left to right from all coins to portfolio coins
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
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .padding(.horizontal)
    }
    
    
    

}

