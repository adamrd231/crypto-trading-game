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
    
    
    @State var showCircleAnimation: Bool = false
    
    @State var showPortfolioView: Bool = false
    
    @State private var selectedTab = "one"

    // Sheet Navigation
    @State private var showDetailView: Bool = false
    
    // Grid spacing variable
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        
    ]
    
    // Grid spacing variable
    private let spacing: CGFloat = 30
    
    
    
    // MARK: Main Body
    // -------------------
    var body: some View {
       
        TabView {
            // First Screen
            portfolioStatsView
                
                .tabItem { VStack {
                    Image(systemName: "bitcoinsign.circle")
                    Text("Market")
                }}
                .tag("one")
            
            // Information on the game
            portfolioView
                .navigationTitle("")
                .navigationBarHidden(true)
//            SettingsView()
//                .navigationTitle("")
//                .navigationBarHidden(true)
                .tabItem { VStack {
                    Image(systemName: "bitcoinsign.circle.fill")
                    Text("Portfolio")
                }}
                .tag("two")
                .onAppear(perform: {
                    selectedTab = "two"
                })
            
            
            
            // Game Options Screen
            NewGameScreen()
                .navigationTitle("")
                .navigationBarHidden(true)
                .tabItem { VStack {
                    Image(systemName: "gamecontroller")
                    Text("Game")
                }}
            
            SettingsView()
                .tabItem { VStack {
                    Image(systemName: "person")
                    Text("About")
                }}
   
            
            // In App Purchases Screen
            InAppStorePurchasesView(storeManager: vm.storeManager).environmentObject(vm)
                .navigationTitle("")
                .navigationBarHidden(true)
                .tabItem { VStack {
                    Image(systemName: "creditcard")
                    Text("In-App")
                }}

        }
        .sheet(isPresented: $showPortfolioView, content: {
            PortfolioView(showPortfolio: $showPortfolioView)
        })
    }
}


// MARK: Previews
// -------------------
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
                .navigationBarHidden(true)
                .environmentObject(dev.homeVM)
        }
    }
}


// MARK: Extension to HomeView
// ----------------------------
extension HomeView {
   
    private var portfolioStatsView: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    Text("Total Coins")
                    Spacer()
                    Text(vm.portfolioCoins.count.description)
                }
                HStack {
                    Text("Total Coin Value")
                    Spacer()
                    Text((vm.portfolioCoins.map({$0.currentHoldingsValue}).reduce(0, +)).asCurrencyWith2Decimals())
                    
                }
                HStack {
                    Text("Money")
                    Spacer()
                    Text(vm.storeManager.game.gameDollars.asCurrencyWith2Decimals())
                    
                }
                HStack {
                    Text("Score")
                    Spacer()
                    Text((vm.storeManager.game.gameDollars + (vm.portfolioCoins.map({$0.currentHoldingsValue}).reduce(0, +))).asCurrencyWith2Decimals())
                    
                }
                HStack {
                    Text("Gain / Loss")
                    Spacer()
                    Text(((vm.storeManager.game.gameDollars + (vm.portfolioCoins.map({$0.currentHoldingsValue}).reduce(0, +))) - 100_000).asCurrencyWith2Decimals())
                    
                }
            }
            
            Divider()
            VStack(alignment: .leading) {
                Text("Owned Coins")
                    .font(.title)
                    .fontWeight(.bold)
                LazyVGrid(
                    columns: columns,
                    alignment: .center,
                    spacing: 10,
                    pinnedViews: [],
                    content: {
                        
                        ForEach(vm.portfolioCoins) { coin in
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    CoinImageView(coin: coin)
                                        .frame(width: 25, height: 25, alignment: .center)
                                    
                                    Spacer()
                                    Text(coin.name.description)
                                }
                                VStack(alignment: .leading) {
                                    Text("Owned")
                                        .fontWeight(.bold)
                                    Text(coin.currentHoldings?.asNumberString() ?? "")
                                }
                                VStack(alignment: .leading) {
                                    Text("Holdings")
                                        .fontWeight(.bold)
                                    Text(coin.currentHoldingsValue.asCurrencyWith2Decimals())
                                }
                                HStack {
                                    Image(systemName: (coin.priceChange24H ?? 1 > 0) ?  "arrow.up.circle" : "arrow.down.circle")
                                        .resizable()
                                        .frame(width: 20, height: 20, alignment: .center)
                                        .foregroundColor(coin.priceChange24H ?? 1 > 0 ? .green : .red)
                                    Text(coin.priceChange24H?.asCurrencyWith2Decimals() ?? "")
                                }
                               
                                
                            }
//                            .frame(width: UIScreen.main.bounds.width / 2.25)
                            .padding()
                            
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                            
                            
                        }
                })
            }
           
        }
        .padding()
        .navigationTitle("Profile")
    }
    
    private var portfolioView: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            
            
            VStack {
                homeHeader
                HomeStatsView(statistics: vm.statistics)
                SearchBarView(searchText: $vm.searchText)
                columnTitlesSecondary
                portfolioCoinsList
                
                if vm.storeManager.purchasedRemoveAds != true {
                    AdMobBanner()
                }
            }
        }
    }
    
    
    private var homeView: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            
            VStack {
                homeHeader
                HomeStatsView(statistics: vm.secondRowStatistics)
                SearchBarView(searchText: $vm.searchText)
                columnTitles
                allCoinsList

                if vm.storeManager.purchasedRemoveAds != true {
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
                    CircleButtonAnimationView(animate: $showCircleAnimation)
                )

            Spacer()
            
            //  Center Description Text
            Text((selectedTab == "one") ? "Live Prices" : "Portfolio")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(Color.theme.accent)
                .animation(.none)
            
            Spacer()
            CircleButtonView(iconName: "plus")
                .opacity(0)
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
                        showDetailView.toggle()
                       
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
    
    private var columnTitlesSecondary: some View {
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

