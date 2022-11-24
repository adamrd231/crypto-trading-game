//
//  NewGameScreen.swift
//  nftApp
//
//  Created by Adam Reed on 2/1/22.
//

import SwiftUI
import GameKit

struct NewGameScreen: View {
    
    @State var vm = HomeViewModel()
    @StateObject var leaderboardVM = BoardModel()
    
    @State var showingAlert: Bool = false
    
    func createAlert() -> Alert {
        return Alert(title: Text("Re-Start Game."), message: Text("Are you sure you want to re-start, there is no way to undo this."),
                          dismissButton: .default(Text("Yes, I am sure.")) {
                            restartGame()
                          })
    }
    
    
    func getTotalPortfolioValue() -> Double {
        let portfolioValue =
            vm.portfolioCoins
                .map({ $0.currentHoldingsValue })
                .reduce(0, +)
        
        let totalGameMoney = vm.storeManager.game.gameDollars
        return portfolioValue + totalGameMoney
    }
    
    func restartGame() {
        vm.storeManager.game.gameDollars = 100000
        vm.storeManager.game.startingDate = Date()
        // Remove all coins from portfolio coins
        vm.portfolioDataService.deleteAllTradeEntities()
        vm.portfolioDataService.deleteAllPortfolioEntities()
    }
    
    
    var body: some View {
        ZStack {
            VStack(spacing: 5) {
                VStack() {
                    Text("Leaderboard")
                        .fontWeight(.bold)
              
                    if leaderboardVM.localPlayer.isAuthenticated != true {
                        Text("Game Center Required.").fontWeight(.medium).padding(.top)
                        Text("Leaderboards are only available if logged into GameCenter... If log-in screen is gone, turn off app and open again.")
                            .font(.caption)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(.top)
                .padding(.horizontal)
                
                List {
                    if let scores = leaderboardVM.topScores {
                        ForEach(scores, id: \.self) { item in
                            HStack {
                                Text("# \(item.rank)")
                                Text(item.player.displayName)
                                Spacer()
                                Text(item.formattedScore)
                            }
                        }
                    }
                    
                }

                Button(action: {
//                        vm.game = GameModel()
                    showingAlert.toggle()
                    
                }) {
                    Text("Start game over")
                }
                .padding()
                .multilineTextAlignment(.center)
                .background(Color.theme.background)
                .cornerRadius(15.0)
                
            }.padding()
            .alert(isPresented: $showingAlert, content: {
                // decide which alert to show
               createAlert()
                
            })
            .onAppear(perform: {
                leaderboardVM.authenticateUser()
                leaderboardVM.addScoreToLeaderBoard(score: getTotalPortfolioValue())
                leaderboardVM.updateScores()
            })
            
        }
    }
}




struct NewGameScreen_Previews: PreviewProvider {
    static var previews: some View {
        NewGameScreen()
    }
}
