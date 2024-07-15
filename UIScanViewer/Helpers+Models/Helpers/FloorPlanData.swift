//
//  FloorPlanData.swift
//  UIFloorPlan
//
//  Created by Sina on 2/23/24.
//

import Foundation
import RoomPlan
import simd

@available(iOS 17.0, *)
public class FloorPlanData {
    
    var roomPlanData: CapturedRoom?
    public init(with roomPlanData: CapturedRoom) {
        self.roomPlanData = roomPlanData
        setup()
    }

    var capturedStructureData: CapturedStructure?
    public init(with capturedStructureData: CapturedStructure) {
        self.capturedStructureData = capturedStructureData
        setup()
    }
    
    private func setup() {
        // create all the objects
        createObjects()
        // calculate size and diffPoint to make objects show on positive x/y axis values
        calcSizeAndDiffPoint()
        // shift the objects
        shiftObjects()
    }
    
    private func floorTransform(story: Int) -> simd_float4x4? {
        return (capturedStructureData?.floors ?? roomPlanData?.floors)?.first(where: { it in
            return it.story == story
        })?.transform
    }

    // MARK: - Objects
    var objects = [FloorPlanObject]()
    var sections = [FloorPlanSection]()
    var areas = [FloorPlanArea]()
    var furnitures = [FurnitureObject]()
    private func createObjects() {
        objects.removeAll()
        // create/process wall objects
        for wall in capturedStructureData?.walls ?? roomPlanData?.walls ?? [] {
            if let floorTransform = floorTransform(story: wall.story) {
                objects.append(
                    FloorPlanObject(objectType: .wall, story: wall.story, floorTransform: floorTransform, surface: wall)
                )
            }
        }
        for window in capturedStructureData?.windows ?? roomPlanData?.windows ?? [] {
            if let floorTransform = floorTransform(story: window.story) {
                objects.append(
                    FloorPlanObject(objectType: .window, story: window.story, floorTransform: floorTransform, surface: window)
                )
            }
        }
        for section in capturedStructureData?.sections ?? roomPlanData?.sections ?? [] {
            if let floorTransform = floorTransform(story: section.story) {
                sections.append(
                    FloorPlanSection(story: section.story, floorTransform: floorTransform, section: section)
                )
            }
        }
        for door in capturedStructureData?.doors ?? roomPlanData?.doors ?? [] {
            if let floorTransform = floorTransform(story: door.story) {
                let doorObject = FloorPlanObject(objectType: .door,
                                                 story: door.story,
                                                 floorTransform: floorTransform,
                                                 surface: door)
                objects.append(doorObject)
                // NO needs to calc `nearSectionPoint` as we don't show arcs/directions for the doors, anymore.
                /*doorObject.nearSectionPoint = doorObject.point1.nearestPoint(among: sections.map({ section in
                    return section.centerPoint
                }))*/
            }
        }
        for opening in capturedStructureData?.openings ?? roomPlanData?.openings ?? [] {
            if let floorTransform = floorTransform(story: opening.story) {
                objects.append(
                    FloorPlanObject(objectType: .opening, story: opening.story, floorTransform: floorTransform, surface: opening)
                )
            }
        }
        // remove opening parts from the walls
        for opening in objects.filter({ it in
            return it.objectType == .opening
        }) {
            for (index, obj) in objects.enumerated() {
                if obj.story != opening.story || obj.objectType != .wall {
                    continue
                }
                if !SurfaceHelpers.isOpeningInsideWall(wallPoint1: obj.point1,
                                                       wallPoint2: obj.point2,
                                                       openingPoint1: opening.point1,
                                                       openingPoint2: opening.point2) {
                    continue
                }
                let newPoint1, newPoint2: CGPoint
                if obj.point1.distance(to: opening.point1) <= obj.point1.distance(to: opening.point2) {
                    newPoint1 = opening.point1
                    newPoint2 = opening.point2
                } else {
                    newPoint1 = opening.point2
                    newPoint2 = opening.point1
                }
                objects.append(
                    FloorPlanObject(objectType: .wall,
                                    story: obj.story,
                                    point1: obj.point1,
                                    point2: newPoint1)
                )
                objects.append(
                    FloorPlanObject(objectType: .wall,
                                    story: obj.story,
                                    point1: newPoint2,
                                    point2: obj.point2)
                )
                objects.remove(at: index)
            }
        }
        
        for furniture in capturedStructureData?.objects ?? roomPlanData?.objects ?? [] {
            if let floorTransform = floorTransform(story: furniture.story) {
                var objectType = FurnitureObject.ObjectType.invalid
                switch furniture.category {
                case .table:
                    objectType = .table
                    break
                case .chair:
                    objectType = .chair
                    break
                case .storage:
                    break
                case .refrigerator:
                    objectType = .refrigerator
                    break
                case .stove:
                    objectType = .stove
                    break
                case .bed:
                    objectType = .bed
                    break
                case .sink:
                    objectType = .sink
                    break
                case .washerDryer:
                    objectType = .washerDryer
                    break
                case .toilet:
                    objectType = .toilet
                    break
                case .bathtub:
                    objectType = .bathtub
                    break
                case .oven:
                    objectType = .oven
                    break
                case .dishwasher:
                    objectType = .dishwasher
                    break
                case .sofa:
                    objectType = .sofa
                    break
                case .fireplace:
                    break
                case .television:
                    break
                case .stairs:
                    break
                @unknown default:
                    break
                }
                furnitures.append(
                    FurnitureObject(objectType: objectType, story: furniture.story, floorTransform: floorTransform, surface: furniture)
                )
            }
        }
        
        // create supported floor plan areas
        for area in capturedStructureData?.objects ?? roomPlanData?.objects ?? [] {
            if let floorTransform = floorTransform(story: area.story) {
                switch area.category {
                case .stairs, .bed:
                    //areas.append(FloorPlanArea(areaType: .stairs, story: area.story,
                    //floorTransform: area.transform, surface: area))
                    break
                case .table, .chair:
                    areas.append(FloorPlanArea(areaType: .table, story: area.story,
                                               floorTransform: floorTransform, surface: area))
                    break
                default:
                    break
                }
            }
        }
    }
    
    // MARK: - Calculations
    var roomSize = CGSize()
    private var diffPoint = CGPoint()
    var stoiesCount = Int()
    private func calcSizeAndDiffPoint() {
        guard !objects.isEmpty else {
            roomSize = CGSize(width: 2 * FloorPlanConfig.containerPadding,
                              height: 2 * FloorPlanConfig.containerPadding)
            diffPoint = .zero
            return
        }

        // find shift x and y / width and height
        var minX = CGFloat.infinity
        var maxX = -CGFloat.infinity
        var minY = CGFloat.infinity
        var maxY = -CGFloat.infinity
        for obj in objects {
            minX = min(minX, obj.point1.x, obj.point2.x)
            maxX = max(maxX, obj.point1.x, obj.point2.x)
            minY = min(minY, obj.point1.y, obj.point2.y)
            maxY = max(maxY, obj.point1.y, obj.point2.y)
            stoiesCount = max(stoiesCount, obj.story + 1)
        }

        roomSize = CGSize(width: maxX - minX + 2 * FloorPlanConfig.containerPadding,
                          height: maxY - minY + 2 * FloorPlanConfig.containerPadding)
        diffPoint = CGPoint(x: FloorPlanConfig.containerPadding - minX,
                            y: FloorPlanConfig.containerPadding - minY)
    }
    
    private func shiftObjects() {
        // shift objects based on diffPoint found
        for obj in objects {
            obj.shift(diffPoint)
        }
        for section in sections {
            section.shift(diffPoint)
        }
        for area in areas {
            area.shift(diffPoint)
        }
        for furniture in furnitures {
            furniture.shift(diffPoint)
        }
    }

}
