//
//  SettingsView.swift
//  nftApp
//
//  Created by Adam Reed on 1/20/22.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    let youtubeTutorialURL: URL?
    let instagramURL: URL?
    let youtubeURL: URL?
    let portfolioURL: URL?
    let coinGeckoURL: URL?
    let githubURL: URL?
    
    @State var showfullDescription: Bool = false
    
    init() {
        self.youtubeTutorialURL = URL(string: "https://www.youtube.com/c/swiftfulthinking")
        self.instagramURL = URL(string: "https://www.instagram.com/adamrd231/")
        self.youtubeURL = URL(string: "https://www.youtube.com/channel/UCEa-HBtYEeJEP3qUJQ1SKVg")
        self.portfolioURL = URL(string: "https://rdconcepts.design/")
        self.coinGeckoURL = URL(string: "https://coingecko.com")
        self.githubURL = URL(string: "https://github.com/adamrd231")
    }
    
    var body: some View {

        List {
            VStack(alignment: .leading, spacing: 5) {
                Text("Crypto-nade Stand Game")
                    .font(.title3)
                    .fontWeight(.light)
                    .multilineTextAlignment(.center)
                Text("Designed & Developed By")
                    .font(.caption)
                    .fontWeight(.light)
                Text("Adam Reed")
                    .font(.caption)
      
            }.padding()
            settingsSection
            coinGeckoSection
            developerSection
            privacyPolicy
        }
        .accentColor(.blue)
        .listStyle(GroupedListStyle())
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarLeading) {
                XmarkButton()
            }
        })
       
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

extension SettingsView {
    
    private var header: some View {
        Text("Header")
    }
    
    private var footer: some View {
        Text("Footer")
    }
    
    private var settingsSection: some View {
        Section(header: Text("About me")) {
            HStack {
                
                Image("adam")
                    .resizable()
                    .frame(width: 100, height: 100)
     
                    .clipShape(RoundedRectangle(cornerRadius: 50.0))
                VStack(alignment: .leading) {
                    Text("Adam Reed").fontWeight(.bold)
                    Text("Developer")
                }
            }
            
                
            VStack(alignment: .leading, spacing: 10) {
                
                Text("This App was made with inspiration from @SwiftfulThinking course on Youtube and utilizing CoinGecko's API for cryptocurrency pricing and information. It uses MVVM architecture, Combine and CoreData. The app was expanded upon by making it into a free to use crptyo trading game.")
                    
                    .lineLimit(showfullDescription ? nil : 3)
                Button( action: {
                    showfullDescription.toggle()
                    
                }) {
                    Text(showfullDescription ? "Less" : "Read More...")
                }
            }
            
            if
                let youtubeURL = youtubeURL,
                let instagramURL = instagramURL,
                let portfolioURL = portfolioURL,
                let githubURL = githubURL {
                Text("More Content")
                Link("YouTube", destination: youtubeURL)
                Link("Instagram", destination: instagramURL)
                Link("Portfolio", destination: portfolioURL)
                Link("Github", destination: githubURL)

            }
            
        }
    }
    
    private var coinGeckoSection: some View {
        Section(header: Text("Coin Gecko API")) {
            Image("coingecko")
                .resizable()
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 50.0))

                
            VStack(alignment: .leading, spacing: 10) {
                
                Text("The cryptocurrency data that is used in this app comes from a free API from CoinGecko! Prices may be slightly delayed.")

            }
            
            if let coinGeckoURL = coinGeckoURL {
                Link("Visit CoinGecko", destination: coinGeckoURL)

            }
            
        }
    }
    
    
    private var developerSection: some View {
        Section(header: Text("Developer Tools")) {
            Image("logo")
                .resizable()
                .frame(width: 100, height: 100)
        
                
            VStack(alignment: .leading, spacing: 10) {
                
                Text("This app was developed by Adam Reed. It uses SwiftUI and is written completely in swift. This project was intended to dive into and get more familiar with multi-threading, publishers and subscribers, as well as data persistence.")
                    


            }
            
            if let websiteURL = portfolioURL {
                Link("My personal website", destination: websiteURL)

            }
            
        }
    }
    
    
    private var privacyPolicy: some View {
        Section(header: Text("Privacy Policy")) {
            Link("Privacy Policy", destination: URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")!)
            
        }
    }
    
}
