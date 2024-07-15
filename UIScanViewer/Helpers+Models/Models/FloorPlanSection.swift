//
//  FloorPlanSection.swift
//  UIFloorPlan
//
//  Created by Sina on 2/23/24.
//

import Foundation
import RoomPlan
import simd

// Sections are rooms in the floor plan. It can be bedroom, bathroom and...
@available(iOS 17.0, *)
class FloorPlanSection {
    
    var story: Int
    var centerPoint: CGPoint
    var section: CapturedRoom.Section

    // init from a section
    init(story: Int, floorTransform: simd_float4x4, section: CapturedRoom.Section) {
        centerPoint = MatrixHelpers.extractCenterPoint(floorTransform: floorTransform, section: section)
        self.story = story
        self.section = section
    }

    func shift(_ diffPoint: CGPoint) {
        centerPoint = centerPoint + diffPoint
    }
}
