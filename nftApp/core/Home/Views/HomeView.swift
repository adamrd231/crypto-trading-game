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
    @State var dailyChangeForPortfolio: Double = 0

    
    // MARK: Main Body
    // -------------------
    var body: some View {
       
        TabView {
            // First Screen
            portfolioStatsView
                .navigationBarHidden(true)
                .navigationTitle("")
                .tabItem { VStack {
                    Image(systemName: "person.crop.circle")
                    Text("Portfolio")
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
                    Text("Market")
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


struct PortfolioStatDouble: View {
    let title: String
    let stat: Double
    
    var body: some View {
        HStack(alignment: .center) {
            Text(title)
                .fontWeight(.bold)
            Spacer()
            Text(stat.asCurrencyWith2Decimals())
        }
    }
}

struct PortfolioStatNumber: View {
    let title: String
    let value: Double
    var body: some View {
        HStack(alignment: .center) {
            Text(title)
                .fontWeight(.bold)
            Spacer()
            Text(String(format: "%.2f", value))
        }
    }
}

struct PortfolioStatDate: View {
    let title: String
    let date: Date
    
    var body: some View {
        HStack(alignment: .center) {
            Text(title)
                .fontWeight(.bold)
            Spacer()
            Text(date.asShortDateString())
        }
    }
}

struct PortfolioStatePercentage: View {
    let title: String
    let value: Double
    var body: some View {
        HStack(alignment: .center) {
            Text(title)
                .fontWeight(.bold)
            Spacer()
            Text(value.asPercentString())
                .foregroundColor(value > 0 ? .green : .red)
        }
    }
}
// MARK: Extension to HomeView
// ----------------------------
extension HomeView {
   
    private var portfolioStatsView: some View {
        ScrollView {
            HStack {
                Text("Portfolio")
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
            }
           
            VStack(alignment: .leading) {
                PortfolioStatDate(title: "Start Date", date: vm.storeManager.game.startingDate)
                PortfolioStatDouble(title: "Money", stat: vm.storeManager.game.gameDollars)
                PortfolioStatDouble(title: "Score", stat: vm.portfolioCoins.map({$0.currentHoldingsValue}).reduce(0, +) + vm.storeManager.game.gameDollars)
            }
            Divider()
            VStack(alignment: .leading) {
                PortfolioStatNumber(title: "Unique Coins", value: Double(vm.portfolioCoins.count))
                PortfolioStatNumber(title: "Total Coins", value: vm.portfolioCoins.map({ $0.currentHoldings ?? 0 }).reduce(0,+))
                PortfolioStatDouble(title: "Total Coin Value", stat: vm.portfolioCoins.map({$0.currentHoldingsValue}).reduce(0, +))
            }
            Divider()
            VStack(alignment: .leading) {
                PortfolioStatePercentage(title: "Daily Change", value: vm.Portfolio24Change)
            }
            
            Divider()
            VStack(alignment: .leading) {
                Text("Owned Coins")
                    .font(.title)
                    .fontWeight(.bold)
                
                if vm.allCoins.count > 0 {
                    LazyVGrid(
                        columns: columns,
                        alignment: .center,
                        spacing: 10,
                        pinnedViews: [],
                        content: {
                            CoinPortfolioView(coins: vm.allCoins)
                    })
                } else {
                    Text("No Coins... Yet.")
                }
            }
        }
        .padding()
    }
    
    private var portfolioView: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            
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
               
                columnTitlesSecondary
                allCoinsList
                
                if vm.storeManager.purchasedRemoveAds != true {
                    AdMobBanner()
                }
            }
        }
    }

    
    private var allCoinsList: some View {
        List {
            ForEach(vm.allCoins) { coin in
                if (vm.portfolioCoins.contains(coin)) {
                    CoinRowView(coin: coin, userOwnsCoin: true)
                        .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 0))
                        .onTapGesture {
                            selectedCoin = coin
                            showDetailView.toggle()
                        }
                        .sheet(isPresented: $showDetailView) {
                            if let coin = selectedCoin {
                                DetailView(coin: coin)
                            }
                        }
                } else {
                    CoinRowView(coin: coin, userOwnsCoin: false)
                        .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 0))
                        .onTapGesture {
                            selectedCoin = coin
                            showDetailView.toggle()
                        }
                        .sheet(isPresented: $showDetailView) {
                            if let coin = selectedCoin {
                                DetailView(coin: coin)
                            }
                        }
                }
            }
        }
        .listStyle(PlainListStyle())
    }
    
    private var portfolioCoinsList: some View {
        List {
            ForEach(vm.portfolioCoins) { coin in
                CoinRowView(coin: coin, userOwnsCoin: true)
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

