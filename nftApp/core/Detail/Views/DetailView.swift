//
//  DetailView.swift
//  nftApp
//
//  Created by Adam Reed on 1/19/22.
//

import SwiftUI

struct DetailView: View {
    
    @StateObject private var vm: DetailViewModel
    @State var homeVM: HomeViewModel = HomeViewModel()
    @State private var showFullDescription: Bool = false
    @State var coin: CoinModel
    @State var userOwnsCoin: Bool

    // Grid spacing variable
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    // Grid spacing variable
    private let spacing: CGFloat = 30
    
    init(coin: CoinModel, userOwnsCoin: Bool) {
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
        self.coin = coin
        self.userOwnsCoin = userOwnsCoin
    }
    
    var body: some View {
        ZStack {
            VStack {
                List {
                    Section(header: Text("Buy or Sell Coins")) {
                        BuySellView(coin: coin)
                            .environmentObject(vm)
                    }
                    Section(header: Text("Coin Information")) {
                        VStack(spacing: 20) {
                            ChartView(coin: vm.coin)
                            // Chart Section
                            overviewTitle
                            Divider()
                            descriptionSection
                            overviewGrid
                            additionalTitle
                            Divider()
                            additionalGrid
                            websiteLinks
                        }
                        .padding()
                    }
                }
                .buttonStyle(BorderedButtonStyle())
            }
        }
        .navigationTitle("\(coin.name)")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                navigationbarTrailingItems
            }
            ToolbarItem(placement: .navigationBarLeading) {
                navigationbarLeadingItems
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {

            DetailView(coin: dev.coin, userOwnsCoin: true)
        
       
    }
}

extension DetailView {
    private var overviewTitle: some View {
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var additionalTitle: some View {
        Text("Additional Details")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var overviewGrid: some View {
        LazyVGrid(
            columns: columns,
            alignment: .leading,
            spacing: spacing,
            pinnedViews: [],
            content: {
                ForEach(vm.overviewStatistics) { stat in
                    StatisticsView(stat: stat)
                }
        })
    }
    
    private var additionalGrid: some View {
        LazyVGrid(
            columns: columns,
            alignment: .leading,
            spacing: spacing,
            pinnedViews: [],
            content: {
                ForEach(vm.additionalStatistics) { stat in
                    StatisticsView(stat: stat)
                }
        })
    }
    
    private var navigationbarLeadingItems: some View {
        HStack {
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .foregroundColor(Color.theme.green)
                .frame(width: 30, height: 30, alignment: .center)
            Text("OWNED")
                .font(.callout)
                .foregroundColor(.gray)
        }
    }
    
    private var navigationbarTrailingItems: some View {
        HStack {
            Text("Rank: \(vm.coin.rank)")
                .font(.headline)
                .foregroundColor(Color.theme.secondaryText)
            CoinImageView(coin: vm.coin)
                .frame(width: 25, height: 25)
        }
        
        
    }
    
    private var descriptionSection: some View {
        ZStack {
            if let coinDescription = vm.coinDescription, !coinDescription.isEmpty {
                VStack(alignment: .leading) {
                    Text(coinDescription)
                        .lineLimit(showFullDescription ? nil : 3)
                        .font(.callout)
                        .foregroundColor(Color.theme.secondaryText)
                    Button(action: {
                        withAnimation(.easeInOut) {
                            showFullDescription.toggle()
                        }
                        
                    }) {
                        Text(showFullDescription ? "Less" : "Read More...")
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.vertical, 4)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
            }
        }
    }
    
    private var websiteLinks: some View {
        VStack(alignment: .leading, spacing: 20) {
            if let websiteString = vm.websiteURL, let url = URL(string: websiteString) {
                Link("Website", destination: url)
            }

            if let redditString = vm.redditURL, let url = URL(string: redditString) {
                Link("Reddit", destination: url)
            }
  
        }
        .accentColor(.blue)
        .frame(maxWidth: .infinity, alignment: .leading)
        .font(.headline)
    }
}
