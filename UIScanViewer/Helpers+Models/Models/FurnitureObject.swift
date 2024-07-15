//
//  FurnitureObject.swift
//  OpalAi
//
//  Created by opal ai on 4/4/24.
//

import Foundation
import RoomPlan
import simd

@available(iOS 17.0, *)
class FurnitureObject {
    // object type
    enum ObjectType {
        case table
        case chair
        case bed
        case refrigerator
        case stove
        case sink
        case washerDryer
        case toilet
        case bathtub
        case oven
        case dishwasher
        case sofa
        case invalid
    }
    let story: Int
    let objectType: ObjectType
    var points: [CGPoint]
    var center: CGPoint
    var width: Double
    var height: Double
    let rotationAngle: Double
    
    init(objectType: ObjectType, story: Int, floorTransform: simd_float4x4, surface: CapturedRoom.Object) {
        self.objectType = objectType
        self.story = story
        self.points = MatrixHelpers.extractRect(floorTransform: floorTransform, surface: surface)
        self.center = MatrixHelpers.extractCenterPoint(floorTransform: floorTransform, surface: surface)
        (self.width, self.height) = MatrixHelpers.extractWidthAndHeight(surface: surface)
        self.width -= 0.13 * FloorPlanConfig.sizeMultiplier
        self.height -= 0.13 * FloorPlanConfig.sizeMultiplier
        self.rotationAngle = MatrixHelpers.extractRotationAngle(floorTransform: floorTransform, surface: surface)
    }

    func shift(_ diffPoint: CGPoint) {
        points = points.map({ point in
            return point + diffPoint
        })
        center = center + diffPoint
    }
}
