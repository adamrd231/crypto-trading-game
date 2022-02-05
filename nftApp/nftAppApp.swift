//
//  nftAppApp.swift
//  nftApp
//
//  Created by Adam Reed on 1/8/22.
//

import SwiftUI
import AppTrackingTransparency
import StoreKit

@main
struct nftAppApp: App {
    
    @StateObject private var vm = HomeViewModel()
    // StoreManager object to make in-app purchases
    @StateObject var storeManager = StoreManager()
    
    var productIDs = ["cryptoRemoveAds"]
    
    private func setupStoreManager() {
        if storeManager.myProducts.isEmpty {
            SKPaymentQueue.default().add(storeManager)
            storeManager.getProducts(productIDs: productIDs)
        }
    }
    
    @State private var showLaunchView:Bool = true
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
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
                    HomeView(storeManager: storeManager)
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
                requestIDFA()
                setupStoreManager()
            })
        }
    }
}
