//
//  Matrix.swift
//  UIFloorPlan
//
//  Created by Sina on 2/23/24.
//

import Foundation
import RoomPlan
import simd

@available(iOS 17.0, *)
struct MatrixHelpers {
    // transform to find the points
    static func transform(transform: simd_float4x4, point: [Double]) -> SIMD3<Float> {
        var p = SIMD4<Float>(Float(point[0]), Float(point[1]), Float(point[2]), 1.0)
        p = transform * p
        return SIMD3<Float>(p.x, p.y, p.z)
    }
    
    static func preprocess(transform: simd_float4x4) -> simd_float4x4 {
        var fTransform = transform
        fTransform[0][3] = fTransform[3][0]
        fTransform[1][3] = fTransform[3][1]
        fTransform[2,3] = fTransform[3][2]
        fTransform[3][0] = 0
        fTransform[3][1] = 0
        fTransform[3][2] = 0
        fTransform[1][0] = transform[2][0]
        fTransform[2][0] = transform[1][0]
        fTransform[1][1] = transform[2][1]
        fTransform[2][1] = transform[1][1]
        fTransform[1][2] = transform[2][2]
        fTransform[2][2] = transform[1][2]
        return fTransform
    }
    
    // extract edge points for surface
    static func extractEdgePoints(floorTransform: simd_float4x4, surface: CapturedRoom.Surface) -> (CGPoint, CGPoint) {
        let fTransform = preprocess(transform: floorTransform)
        
        let sin = Double(surface.transform[0][2])
        let cos = Double(surface.transform[0][0])
        let l = Double(surface.dimensions[0] / 2.0)
        
        let x = Double(surface.transform[3][0])
        let z = Double(surface.transform[3][2])
        
        // extract edge points
        let p1 = MatrixHelpers.transform(transform: simd_inverse(fTransform), point: [x + l * cos, 0, z + l * sin])
        let p2 = MatrixHelpers.transform(transform: simd_inverse(fTransform), point: [x - l * cos, 0, z - l * sin])
        
        let point1 = CGPoint(x: Double(-p1.x) * FloorPlanConfig.sizeMultiplier,
                             y: Double(p1.z) * FloorPlanConfig.sizeMultiplier)
        let point2 = CGPoint(x: Double(-p2.x) * FloorPlanConfig.sizeMultiplier,
                             y: Double(p2.z) * FloorPlanConfig.sizeMultiplier)
        
        return (point1, point2)
    }
    
    static func extractCenterPoint(floorTransform: simd_float4x4, section: CapturedRoom.Section) -> CGPoint {
        let fTransform = preprocess(transform: floorTransform)
        let x = Double(section.center.x)
        let z = Double(section.center.z)
        
        let p = MatrixHelpers.transform(transform: simd_inverse(fTransform), point: [x, 0, z])
        
        let centerPoint = CGPoint(x: Double(-p.x) * FloorPlanConfig.sizeMultiplier,
                             y: Double(p.z) * FloorPlanConfig.sizeMultiplier)
        
        return centerPoint
    }
    
    static func extractCenterPoint(floorTransform: simd_float4x4, surface: CapturedRoom.Object) -> CGPoint {
        let fTransform = preprocess(transform: floorTransform)
        let x = Double(surface.transform[3][0])
        let z = Double(surface.transform[3][2])
        
        let p = MatrixHelpers.transform(transform: simd_inverse(fTransform), point: [x, 0, z])
        
        let centerPoint = CGPoint(x: Double(-p.x) * FloorPlanConfig.sizeMultiplier,
                             y: Double(p.z) * FloorPlanConfig.sizeMultiplier)
        
        return centerPoint
    }
    
    static func extractWidthAndHeight(surface: CapturedRoom.Object) -> (Double, Double) {
        let width = Double(surface.dimensions[0]) * FloorPlanConfig.sizeMultiplier
        let height = Double(surface.dimensions[2]) * FloorPlanConfig.sizeMultiplier
        return (width, height)
    }
    
    static func extractRotationAngle(floorTransform: simd_float4x4, surface: CapturedRoom.Object) -> Double {
        let fTransform = preprocess(transform: floorTransform)
        
        let sin = Double(surface.transform[0][2])
        let cos = Double(surface.transform[0][0])
        let l = Double(surface.dimensions[0] / 2.0)

        let x = Double(surface.transform[3][0])
        let z = Double(surface.transform[3][2])
        
        // extract edge points
        let p1 = MatrixHelpers.transform(transform: simd_inverse(fTransform), point: [x + l * cos, 0, z + l * sin])
        let p2 = MatrixHelpers.transform(transform: simd_inverse(fTransform), point: [x - l * cos, 0, z - l * sin])
        //let centerPoint = extractCenterPoint(floorTransform: floorTransform, surface: surface)
        let v1 = CGPoint(x: -2 * l, y: 0)
        let v2 = CGPoint(x: -(Double(p1.x) - Double(p2.x)), y: Double(p1.z) - Double(p2.z))
        let angle = atan2(v2.y, v2.x) - atan2(v1.y, v1.x)
        //let dot = v1.x*v2.x + v1.y*v2.y
        //let det = v1.x*v2.y - v1.y*v2.x
        //let angle = atan2(det, dot)
        print("rotationAngle:", angle / CGFloat.pi * 180)
        return angle
        /*let resTranform = preprocess(transform: floorTransform) * preprocess(transform: surface.transform)
        var angle = Double(acos(resTranform[0][0]))
        let centerPoint = extractCenterPoint(floorTransform: floorTransform, surface: surface)
        print("rotationAngle:", angle / CGFloat.pi * 180)
        if angle == 0 {
          angle = CGFloat.pi
        } else if angle < CGFloat.pi / 2 && angle > 0 {
            angle = CGFloat.pi - angle
        } else if angle == CGFloat.pi / 2 {
            
        } else if angle < CGFloat.pi {
            angle = CGFloat.pi - angle
        } else if angle == CGFloat.pi {
            angle = 0
        } else if angle < 3 * CGFloat.pi / 2 {
            angle = CGFloat.pi - angle
        } else if angle == 3 * CGFloat.pi / 2 {
            
        } else {
            angle = angle - 2 * CGFloat.pi
        }
        return angle*/
    }
    
    // extract rect points for surface
    static func extractRect(floorTransform: simd_float4x4, surface: CapturedRoom.Object) -> [CGPoint] {
        let fTransform = preprocess(transform: floorTransform)
        
        let sin = Double(surface.transform[0][2])
        let cos = Double(surface.transform[0][0])
        let l = Double(surface.dimensions[0] / 2.0)
        let l2 = Double(surface.dimensions[2] / 2.0)

        let x = Double(surface.transform[3][0])
        let z = Double(surface.transform[3][2])
        
        // extract edge points
        let p1 = MatrixHelpers.transform(transform: simd_inverse(fTransform), point: [x + l * cos, 0, z + l * sin])
        let p2 = MatrixHelpers.transform(transform: simd_inverse(fTransform), point: [x - l * cos, 0, z - l * sin])
        let v1 = SIMD3<Float>(-p1.x, p1.z, 0)
        let v2 = SIMD3<Float>(-p2.x, p2.z, 0)
        var delta = get_detla_for_thickness(p1: v1, p2: v2, thickness: Float(l2*2))
        delta = delta / 2
        let u1 = v1 + delta
        let u2 = v2 + delta
        let u3 = v1 - delta
        let u4 = v2 - delta
        let point1 = CGPoint(x: Double(u1.x) * FloorPlanConfig.sizeMultiplier,
                             y: Double(u1.y) * FloorPlanConfig.sizeMultiplier)
        let point2 = CGPoint(x: Double(u2.x) * FloorPlanConfig.sizeMultiplier,
                             y: Double(u2.y) * FloorPlanConfig.sizeMultiplier)
        let point3 = CGPoint(x: Double(u3.x) * FloorPlanConfig.sizeMultiplier,
                             y: Double(u3.y) * FloorPlanConfig.sizeMultiplier)
        let point4 = CGPoint(x: Double(u4.x) * FloorPlanConfig.sizeMultiplier,
                             y: Double(u4.y) * FloorPlanConfig.sizeMultiplier)
        return [point1, point2, point3, point4]
    }
    
    static func get_detla_for_thickness(p1: SIMD3<Float>, p2: SIMD3<Float>,  thickness: Float) -> SIMD3<Float>{
        let delta: SIMD3<Float>
        if p1[0] == p2[0] {
            delta = SIMD3<Float>(thickness, 0, 0)
        } else if p1[1] == p2[1] {
            delta = SIMD3<Float>(0, thickness, 0)
        } else {
            let slope = (p2[1] - p1[1]) / (p2[0] - p1[0])
            let slope_of_perpendicular = -1/slope
            let theta = atan(slope_of_perpendicular)
            delta = SIMD3<Float>(cos(theta)*thickness, sin(theta)*thickness, 0)
        }
        return delta
    }
}
