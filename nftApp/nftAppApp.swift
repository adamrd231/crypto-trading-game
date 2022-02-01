//
//  nftAppApp.swift
//  nftApp
//
//  Created by Adam Reed on 1/8/22.
//

import SwiftUI

@main
struct nftAppApp: App {
    
    @StateObject private var vm = HomeViewModel()
    
    @State private var showLaunchView:Bool = true
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
    }
    
    var body: some Scene {
        WindowGroup {
            
            ZStack {
                NavigationView {
                    HomeView()
                        .navigationBarHidden(true)
                }
                .environmentObject(vm)
                
                ZStack {
                    if showLaunchView {
                        LaunchView(showLaunchView: $showLaunchView)
                            .transition(.move(edge: .leading))
                            
                    }
                }
                .zIndex(2.0)
  
                
            }
        }
    }
}
