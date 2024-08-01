//
//  MovementFunction.swift
//  ParabolicMovementLayout
//
//  Created by Heorhi Heilik on 31.07.24.
//

import Foundation

internal extension ParabolicMovementCollectionViewLayout {

    struct MovementFunction {

        // MARK: Internal properties

        let startVelocity: CGFloat
        let startPosition: CGFloat

        let accelerationCoefficient: CGFloat
        let contentOffsetOfParabolaVertex: CGFloat

        // MARK: Initialization

        init(startVelocity: CGFloat, startPosition: CGFloat) {
            self.startVelocity = startVelocity
            self.startPosition = startPosition

            self.accelerationCoefficient = pow(startVelocity, 2) / (4 * startPosition)
            self.contentOffsetOfParabolaVertex = -startVelocity / (2 * accelerationCoefficient)
        }

        // MARK: Internal methods

        func position(for contentOffset: CGFloat) -> CGFloat {
            accelerationCoefficient * pow(contentOffset, 2)  // x^2
            + startVelocity * contentOffset                  // x^1
            + startPosition                                  // x^0
        }

        /// This function solves the equation that defines movement.
        ///
        /// The equation is:
        /// ```
        /// AC * x^2 + SV * x + SP = RP, where
        ///     AC is Acceleration Coeffecient (to be consice, acceleration coefficient is acceleration divided by 2,
        ///         but real acceleration value is not important here),
        ///     SV is Start Velocity,
        ///     SP is Start Position,
        ///     PS is PoSition, or y.
        /// ```
        ///
        /// Applying some modifications:
        /// ```
        /// AC * x^2 + SV * x + (SP - PS) = 0
        /// ```
        ///
        /// Now we can solve equation with discriminant.
        /// ```
        /// Let DS = DiScriminant, then
        /// DS = b^2 - 4 * a * c
        ///
        /// a = AC
        /// b = SV^2
        /// c = SP - PS
        ///
        /// DS = SV^2 - 4 * AC * (SP - PS)
        /// ```
        ///
        func contentOffsets(for position: CGFloat) -> (CGFloat, CGFloat) {
            let discriminant = pow(startVelocity, 2) - 4 * accelerationCoefficient * (startPosition - position)
            guard discriminant >= 0 else {
                assertionFailure("Equation has no roots for provided position (\(position))!")
                return (.zero, .zero)
            }
            let discriminantSqrt = discriminant.squareRoot()

            let x1 = (-startVelocity - discriminantSqrt) / (2 * accelerationCoefficient)
            let x2 = (-startVelocity + discriminantSqrt) / (2 * accelerationCoefficient)

            return (x1, x2)
        }

    }

}
