//
//  ContentView.swift
//  nftApp
//
//  Created by Adam Reed on 1/8/22.
//

import SwiftUI

struct ContentView: View {
    
    
    
    var body: some View {
        NavigationView {
            HomeView()
                .navigationBarHidden(true)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
