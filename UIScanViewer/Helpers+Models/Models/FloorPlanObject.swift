//
//  FloorPlanObject.swift
//  UIFloorPlan
//
//  Created by Sina on 2/23/24.
//

import Foundation
import RoomPlan
import simd

@available(iOS 17.0, *)
class FloorPlanObject {
    // object type
    enum ObjectType {
        case wall
        case window
        case door
        case opening
    }
    let story: Int
    let objectType: ObjectType
    
    // points of the object on the floor
    var point1: CGPoint
    var point2: CGPoint
    let thickness: CGFloat
    
    // nearest section (room) point. (used for doors to indicate the angle)
    //var nearSectionPoint: CGPoint? = nil

    // init from a surface
    init(objectType: ObjectType, story: Int, floorTransform: simd_float4x4, surface: CapturedRoom.Surface) {
        self.objectType = objectType
        self.story = story

        // extract edge points
        (point1, point2) = MatrixHelpers.extractEdgePoints(floorTransform: floorTransform, surface: surface)

        // default thickness
        thickness = CGFloat(0.1 * FloorPlanConfig.sizeMultiplier)
    }
    
    init(objectType: ObjectType, story: Int, point1: CGPoint, point2: CGPoint) {
        self.objectType = objectType
        self.story = story
        self.point1 = point1
        self.point2 = point2
        thickness = CGFloat(0.1 * FloorPlanConfig.sizeMultiplier)
    }
    
    func shift(_ diffPoint: CGPoint) {
        point1 = point1 + diffPoint
        point2 = point2 + diffPoint
    }
    
    var length: CGFloat {
        return point2.distance(to: point1)
    }
}
