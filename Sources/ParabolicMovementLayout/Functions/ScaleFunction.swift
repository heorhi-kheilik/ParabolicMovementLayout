//
//  ScaleFunction.swift
//  ParabolicMovementLayout
//
//  Created by Heorhi Heilik on 1.08.24.
//

import Foundation

internal extension ParabolicMovementCollectionViewLayout {

    struct ScaleFunction {

        // MARK: Internal properties

        let contentOffsetOfParabolaVertex: CGFloat
        let scaleAtVertex: CGFloat

        // MARK: Initialization

        init(contentOffsetOfParabolaVertex: CGFloat, scaleAtVertex: CGFloat) {
            self.contentOffsetOfParabolaVertex = contentOffsetOfParabolaVertex
            self.scaleAtVertex = scaleAtVertex
        }

        // MARK: Internal methods

        func scale(for contentOffset: CGFloat) -> CGFloat {
            (scaleAtVertex - 1) * contentOffset / contentOffsetOfParabolaVertex + 1
        }

    }

}
