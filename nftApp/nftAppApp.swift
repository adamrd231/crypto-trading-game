//
//  nftAppApp.swift
//  nftApp
//
//  Created by Adam Reed on 1/8/22.
//

import SwiftUI
import AppTrackingTransparency

@main
struct nftAppApp: App {
    
    @StateObject private var vm = HomeViewModel()
//    @StateObject var storeManager = StoreManager()
    
//    var productIDs = [
//        "cryptoRemoveAds",
//        "design.rdconcepts.purchaseOneThousand",
//        "design.rdconcepts.crypto.fiveThousand",
//        "design.rdconcepts.crypto.tenThousand",
//        "design.rdconepts.crypto.fifteenThousand",
//        "design.rdconcepts.crypto.twentyFiveThousand",
//        "design.rdconcepts.crypto.oneHundredThousand",
//    ]
    
    
    
    @State private var showLaunchView:Bool = true
    
    init() {
        
       
        
    }
    
    // App Tracking Transparency - Request permission and play ads on open only
    private func requestIDFA() {
      ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
        // Tracking authorization completed. Start loading ads here.
 
      })
    }
    
    var body: some Scene {
        WindowGroup {
            
            ZStack {
                NavigationView {
                    HomeView()
                        .environmentObject(vm)

                }.navigationViewStyle(StackNavigationViewStyle())
                
                
                ZStack {
                    if showLaunchView {
                        LaunchView(showLaunchView: $showLaunchView)
                            .transition(.move(edge: .leading))
                            
                    }
                }
                .zIndex(2.0)

            }
            .onAppear(perform: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    requestIDFA()
                }
                
//                setupStoreManager()
            })
        }
    }
}
