//
//  HomeStatsView.swift
//  nftApp
//
//  Created by Adam Reed on 1/18/22.
//

import SwiftUI

struct HomeStatsView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    
    @Binding var showPortfolio: Bool
    
    var body: some View {
        VStack {
            HStack {
                ForEach(vm.statistics) { stat in
                    StatisticsView(stat: stat)
                        .frame(width: UIScreen.main.bounds.width / 3)
                }
            }
            HStack {
                ForEach(vm.secondRowStatistics) { stat in
                    StatisticsView(stat: stat)
                        .frame(width: UIScreen.main.bounds.width / 3)
                }
            }
            .padding(.top, 5)
        }
        .frame(width: UIScreen.main.bounds.width,
               alignment: showPortfolio ? .trailing : .leading)
    }
}

struct HomeStatsView_Previews: PreviewProvider {
    static var previews: some View {
        HomeStatsView(showPortfolio: .constant(false)).environmentObject(dev.homeVM)
    }
}
