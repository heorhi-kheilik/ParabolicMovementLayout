//
//  IndexPathFormatter.swift
//  CardCollection
//
//  Created by Heorhi Heilik on 28.08.24.
//

import Foundation

enum IndexPathFormatter {

    static func last4Digits(for indexPath: IndexPath) -> String {
        var last4Digits = String(indexPath.row)
        let zeroesToPrependCount = max(0, 4 - last4Digits.count)
        return String(repeating: "0", count: zeroesToPrependCount) + last4Digits
    }

}
