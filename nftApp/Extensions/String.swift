//
//  String.swift
//  nftApp
//
//  Created by Adam Reed on 1/20/22.
//

import Foundation

extension String {
    
    var removingHTMLOccurances: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
    func formatNumber(numberString: String) -> String {
        // Create a new variable to mutate value
        var newString = numberString
        // Check for and remove all cases of commas
        let comma: Set<Character> = [","]
        newString.removeAll(where: {comma.contains($0)})
        
        // Unwrap optional double - should recieve a value
        if let number = Double(numberString) {
            
            // Create a number formatter
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 6
            
            let number = NSNumber(value: number)
            if let formattedValue = formatter.string(from: number) {
                return formattedValue
            } else {
                return ""
            }
        }
        return ""
    }
    
//    func formatNumber(number: Double) -> String {
//
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .decimal
//        formatter.maximumFractionDigits = numberOfDecimals
//
//        let number = NSNumber(value: number)
//        let formattedValue = formatter.string(from: number)!
//
//        return formattedValue
//    }
    
}


