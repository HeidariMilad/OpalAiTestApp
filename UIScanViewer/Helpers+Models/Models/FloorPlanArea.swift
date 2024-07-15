//
//  FloorPlanArea.swift
//  UIFloorPlan
//
//  Created by Sina on 3/3/24.
//

import Foundation
import RoomPlan
import simd

// An area can be filled by appliances or stairs, for example.
@available(iOS 17.0, *)
class FloorPlanArea {
    // object type
    enum AreaType {
        case stairs
        case table
    }
    let story: Int
    let areaType: AreaType
    
    // rect of the area on the floor
    var points: [CGPoint]
    
    // nearest section (room) point. (used for doors to indicate the angle)
    //var nearSectionPoint: CGPoint? = nil
    
    // init from a surface
    init(areaType: AreaType, story: Int, floorTransform: simd_float4x4, surface: CapturedRoom.Object) {
        self.areaType = areaType
        self.story = story
        
        // extract edge points
        points = MatrixHelpers.extractRect(floorTransform: floorTransform, surface: surface)
    }
    
    func shift(_ diffPoint: CGPoint) {
        points = points.map({ point in
            return point + diffPoint
        })
    }
}
