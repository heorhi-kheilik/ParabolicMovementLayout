//
//  GradientProvider.swift
//  CardCollection
//
//  Created by Heorhi Heilik on 8.09.24.
//

import UIKit

struct GradientProvider {

    enum GradientType {
        case blue
        case green
        case orange
        case pink
    }

    private enum Colors {
        static let blue_0 = UIColor(named: "gradient_blue_0")!
        static let blue_1 = UIColor(named: "gradient_blue_1")!
        static let green_0 = UIColor(named: "gradient_green_0")!
        static let green_1 = UIColor(named: "gradient_green_1")!
        static let orange_0 = UIColor(named: "gradient_orange_0")!
        static let orange_1 = UIColor(named: "gradient_orange_1")!
        static let pink_0 = UIColor(named: "gradient_pink_0")!
        static let pink_1 = UIColor(named: "gradient_pink_1")!
    }

    static func gradient(ofType type: GradientType) -> CAGradientLayer {
        let layer = CAGradientLayer()
        layer.startPoint = .init(x: 0, y: 0)
        layer.endPoint = .init(x: 1, y: 1)
        layer.colors = switch type {
        case .blue:
            [Colors.blue_0.cgColor, Colors.blue_1.cgColor]
        case .green:
            [Colors.green_0.cgColor, Colors.green_1.cgColor]
        case .orange:
            [Colors.orange_0.cgColor, Colors.orange_1.cgColor]
        case .pink:
            [Colors.pink_0.cgColor, Colors.pink_1.cgColor]
        }
        return layer
    }

}
