//
//  Published.swift
//  nftApp
//
//  Created by Adam Reed on 1/31/22.
//

import Foundation
import Combine

private var cancellable = [String:AnyCancellable]()

extension Published {
    init(wrappedValue value: Value, key: String) {
        let value = UserDefaults.standard.object(forKey: key) as? Value ?? value
        self.init(initialValue: value)
        cancellable[key] = projectedValue.sink { val in
            UserDefaults.standard.set(val, forKey: key)
        }
    }
}
