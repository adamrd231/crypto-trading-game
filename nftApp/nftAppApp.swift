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
    private func requestIDFA() {
      ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
      })
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .onAppear(perform: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    requestIDFA()
                }
            })
        }
    }
}
