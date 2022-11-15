//
//  HomeStatsView.swift
//  nftApp
//
//  Created by Adam Reed on 1/18/22.
//

import SwiftUI

struct HomeStatsView: View {
    
    var statistics: [StatisticsModel]
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                ForEach(statistics) { stat in
                    StatisticsView(stat: stat)
                        .frame(width: UIScreen.main.bounds.width / 3.1)
                }
            }
        }
        .padding(.bottom, 3)
        .frame(height: UIScreen.main.bounds.height * 0.075)
    }
}

struct HomeStatsView_Previews: PreviewProvider {
    static var previews: some View {
        HomeStatsView(statistics: [dev.stat1, dev.stat2, dev.stat3])
    }
}
