//
//  2dSurfaceHelpers.swift
//  UIFloorPlan
//
//  Created by Sina on 3/3/24.
//

import Foundation

class SurfaceHelpers {
    static func arePointsOnSameLine(_ point1: CGPoint, _ point2: CGPoint, _ point3: CGPoint) -> Bool {
        // Calculate the cross product to determine collinearity
        let crossProduct = (point2.y - point1.y) * (point3.x - point2.x) - (point3.y - point2.y) * (point2.x - point1.x)
        
        // Check if the cross product is within the tolerance level
        return abs(crossProduct) < 0.1
    }

    static func isOpeningInsideWall(wallPoint1: CGPoint, wallPoint2: CGPoint, openingPoint1: CGPoint, openingPoint2: CGPoint) -> Bool {
        // Check if opening points are on the same line as the wall
        guard SurfaceHelpers.arePointsOnSameLine(wallPoint1, wallPoint2, openingPoint1),
              SurfaceHelpers.arePointsOnSameLine(wallPoint1, wallPoint2, openingPoint2) else {
            return false
        }

        // Check if opening points are within the range of wall points
        let isPoint1Inside = openingPoint1.x >= min(wallPoint1.x, wallPoint2.x) &&
                             openingPoint1.x <= max(wallPoint1.x, wallPoint2.x) &&
                             openingPoint1.y >= min(wallPoint1.y, wallPoint2.y) &&
                             openingPoint1.y <= max(wallPoint1.y, wallPoint2.y)

        let isPoint2Inside = openingPoint2.x >= min(wallPoint1.x, wallPoint2.x) &&
                             openingPoint2.x <= max(wallPoint1.x, wallPoint2.x) &&
                             openingPoint2.y >= min(wallPoint1.y, wallPoint2.y) &&
                             openingPoint2.y <= max(wallPoint1.y, wallPoint2.y)

        // Return true if both points are on the same line and within the wall boundary
        return isPoint1Inside && isPoint2Inside
    }

}
