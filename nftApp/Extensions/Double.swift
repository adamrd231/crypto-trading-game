//
//  Double.swift
//  nftApp
//
//  Created by Adam Reed on 1/13/22.
//

import Foundation





extension Double {
    
    /// Converts a double into currency with 2 decimal places
    /// ```
    /// Convert 123456.56 to $1,234.56
    ///
    /// ```
    
    private var currencyFormatter2: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        // formatter.locale = .current // <- Default Value
        // formatter.currencyCode = "usd" // <- Change Currency
        // formatter.currencySymbol = "$" // <- Change Currency Symbol
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        return formatter
    }
    
    
    /// Converts a double into Currency as  a string with 2-6 decimal places
    /// ```
    /// Convert 123456.56 to "$1,234.56"
    /// ```
    
    func asCurrencyWith2Decimals() -> String {
        let number = NSNumber(value: self)
        return currencyFormatter2.string(from: number) ?? "$0.00"
    }
    
    private var currencyFormatter6: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        // formatter.locale = .current // <- Default Value
        // formatter.currencyCode = "usd" // <- Change Currency
        // formatter.currencySymbol = "$" // <- Change Currency Symbol
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 6
        
        return formatter
    }
    
    
    /// Converts a double into Currency as  a string with 2-6 decimal places
    /// ```
    /// Convert 123456.56 to "$1,234.56"
    /// Convert 12.345656 to "$12.3456"
    /// Convert 0.12345656 to "$0.123456"
    ///
    /// ```
    
    func asCurrencyWith6Decimals() -> String {
        let number = NSNumber(value: self)
        return currencyFormatter6.string(from: number) ?? "$0.00"
    }
    
    
    /// Converts a double into a string representation
    /// ```
    /// Convert 1.2345 to "1.23"
    ///
    /// ```
    
    func asNumberString() -> String {
        return String(format: "%.2f", self)
    }
    
    func asNumberStringWithFourDecimals() -> String {
        return String(format: "%.4f", self)
    }
    
    func asNumberStringWithSixDecimals() -> String {
        return String(format: "%.6f", self)
    }
    
    
    /// Converts a double into a string representation with a percent symbol
    /// ```
    /// Convert 1.2345 to "1.23%"
    ///
    /// ```
    
    func asPercentString() -> String {
        return asNumberString() + "%"
    }
    
    func formattedwithAbbreviations() -> String {
        let num = abs(Double(self))
        let sign = (self < 0) ? "-" : ""
        
        switch num {
        case 1_000_000_000_000...:
            let formatted = num / 1_000_000_000_000
            let stringFormatted = formatted.asNumberString()
            return "\(sign)\(stringFormatted)Tr"
        case 1_000_000_000...:
            let formatted = num / 1_000_000_000
            let stringFormatted = formatted.asNumberString()
            return "\(sign)\(stringFormatted)Bn"
        case 1_000_000...:
            let formatted = num / 1_000_000
            let stringFormatted = formatted.asNumberString()
            return "\(sign)\(stringFormatted)M"
        case 1_000...:
            let formatted = num / 1_000
            let stringFormatted = formatted.asNumberString()
            return "\(sign)\(stringFormatted)K"
        case 0...:
            return self.asNumberString()
        default:
            return "\(sign)\(self)"
        }
    }
    
}
