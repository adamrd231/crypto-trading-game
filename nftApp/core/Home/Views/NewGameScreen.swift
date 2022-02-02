//
//  NewGameScreen.swift
//  nftApp
//
//  Created by Adam Reed on 2/1/22.
//

import SwiftUI

struct NewGameScreen: View {
    
    @EnvironmentObject var vm: HomeViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State var counter: Int = 0
    @State var time: Int = 3
    @State var isLoading: Bool = false
    
    var timer = Timer.publish(every: 1.0, on: .main, in: .common)
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                VStack(spacing: 5) {
                    Text("Crypto Lemondade Stand Game")
                        
                        .font(.title3)
                        .fontWeight(.light)
                        .multilineTextAlignment(.center)
                    Text("Designed & Developed By")
                        .font(.caption)
                        .fontWeight(.light)
                    Text("Adam Reed")
                        .font(.callout)
                        .fontWeight(.medium)
                        .padding(.bottom)
                    Button(action: {
                        timer.connect()
                        vm.game.gameDollars = 100000
                        vm.game.startingDate = Date()
                        // Remove all coins from portfolio coins
                        vm.portfolioDataService.deleteAllTradeEntities()
                        vm.portfolioDataService.deleteAllPortfolioEntities()
                    }) {
                        Text("Start game over")
                    }
                    .padding()
                    .multilineTextAlignment(.center)
                    .background(Color.theme.background)
                    .cornerRadius(15.0)
                    
                }
                Spacer()
                VStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Return to Game")
                            .padding()
                            .font(.callout)
                    }
                }
            }.padding()
            
            HStack {
                ProgressView()
                    
                    .onReceive(timer, perform: { _ in
                        withAnimation(.easeIn) {
                            if counter < time {
                                isLoading = true
                                counter += 1
                            } else {
                                counter = 0
                                isLoading = false
                                timer.connect().cancel()
                            }
                        }
                    })
            }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .background(Color.theme.background)
            .opacity(isLoading ? 1.0 : 0.0)
            
        
        }
    }
}

struct NewGameScreen_Previews: PreviewProvider {
    static var previews: some View {
        NewGameScreen()
    }
}
