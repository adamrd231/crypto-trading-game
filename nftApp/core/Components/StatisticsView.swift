//
//  StatisticsView.swift
//  nftApp
//
//  Created by Adam Reed on 1/16/22.
//

import SwiftUI

struct StatisticsView: View {
    
    let stat: StatisticsModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 4) {
            Text(stat.title)
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
            Text(stat.value)
                .font(.headline)
                .foregroundColor(Color.theme.accent)
            HStack(spacing: 5) {
                Image(systemName: "triangle.fill")
                    .font(.caption2)
                    .rotationEffect(Angle(degrees:
                                        stat.percentageChanged ?? 0 >= 0 ? 0 : 180))
                Text(stat.percentageChanged?.asPercentString() ?? "")
            }
            .foregroundColor(stat.percentageChanged ?? 0 >= 0 ? Color.theme.green : Color.theme.red)
            .opacity(stat.percentageChanged == nil ? 0 : 1.0)
            
            
        }
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StatisticsView(stat: dev.stat1)
                .previewLayout(.sizeThatFits)
                .padding()
            StatisticsView(stat: dev.stat1)
                .previewLayout(.sizeThatFits)
                .padding()
                .preferredColorScheme(.dark)
            StatisticsView(stat: dev.stat2)
                .previewLayout(.sizeThatFits)
                .padding()
            StatisticsView(stat: dev.stat3)
                .previewLayout(.sizeThatFits)
                .padding()
                
            StatisticsView(stat: dev.stat3)
                .previewLayout(.sizeThatFits)
                .padding()
                .preferredColorScheme(.dark)
               
        }
        
    }
}
