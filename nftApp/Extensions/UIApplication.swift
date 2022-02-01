//
//  UIApplication.swift
//  nftApp
//
//  Created by Adam Reed on 1/16/22.
//

import Foundation
import SwiftUI
 

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
