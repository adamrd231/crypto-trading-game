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

    // MARK: Main Body
    // -------------------
    var body: some View {
        TabView {
            // First Screen
            UserPortfolioOverview()
                .environmentObject(vm)
                .navigationBarHidden(true)
                .navigationTitle("")
                .tabItem { VStack {
                    Image(systemName: "person.crop.circle")
                    Text(vm.portfolioCoins.count > 0 ? "Portfolio" : "Welcome")
                }}
                .padding()
                .tag("one")
            
            // Information on the game
            CoinMarketView().environmentObject(vm)
                .navigationTitle("")
                .navigationBarHidden(true)
                .tabItem { VStack {
                    Image(systemName: "bitcoinsign.circle.fill")
                    Text("Market")
                }}
                .tag("two")
            
            // Game Options Screen
            NewGameScreen()
                .navigationTitle("")
                .navigationBarHidden(true)
                .tabItem { VStack {
                    Image(systemName: "gamecontroller")
                    Text("Game")
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
        .edgesIgnoringSafeArea(.all)
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

