import SwiftUI
import GoogleMobileAds

struct HomeView: View {
    
    @StateObject private var vm = HomeViewModel()
    @State private var selectedCoin: CoinModel? = nil
    @State var showCircleAnimation: Bool = false
    @State var showPortfolioView: Bool = false
    @State var showWelcomeScreen: Bool = false
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
            UserPortfolioOverview()
                .navigationBarHidden(true)
                .navigationTitle("")
                .tabItem { VStack {
                    Image(systemName: "person.crop.circle")
                    Text(vm.portfolioCoins.count > 0 ? "Portfolio" : "Welcome")
                }}
                .padding()
                .tag("one")
            
            // Information on the game
            cryptoCoinList
                .navigationTitle("")
                .navigationBarHidden(true)
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
            
            UserTradeActivityView()
                .navigationTitle("")
                .navigationBarHidden(true)
                .tabItem { VStack {
                    Image(systemName: "person")
                    Text("Trades")
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
    
    private var cryptoCoinList: some View {
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
