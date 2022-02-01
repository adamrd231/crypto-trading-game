//
//  StatisticsModel.swift
//  nftApp
//
//  Created by Adam Reed on 1/16/22.
//

import Foundation

struct StatisticsModel: Identifiable {
    let id = UUID().uuidString
    let title: String
    let value: String
    let percentageChanged: Double?
    
    init(title: String, value: String, percentageChanged: Double? = nil) {
        self.title = title
        self.value = value
        self.percentageChanged = percentageChanged
    }
}


