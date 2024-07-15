//
//  CGPoint+Extensions.swift
//  UIFloorPlan
//
//  Created by Sina on 2/23/24.
//

import UIKit

extension CGPoint {
    static func +(p1: CGPoint, p2: CGPoint) -> CGPoint {
        return CGPoint(x: p1.x + p2.x, y: p1.y + p2.y)
    }
    func distance(to point: CGPoint) -> CGFloat {
        return hypot(point.x - self.x, point.y - self.y)
    }
    func nearestPoint(among points: [CGPoint]) -> CGPoint? {
        guard !points.isEmpty else { return nil }

        var nearestPoint: CGPoint = points[0]
        var minDistance = distance(to: nearestPoint)

        for point in points {
            let distance = distance(to: point)
            if distance < minDistance {
                minDistance = distance
                nearestPoint = point
            }
        }

        return nearestPoint
    }
}
