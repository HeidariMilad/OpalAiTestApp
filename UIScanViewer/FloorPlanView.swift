//
//  FloorPlanView.swift
//  UIScanViewer
//
//  Created by Milad on 7/14/24.
//

import UIKit
import simd
import UIComponents

@available(iOS 17.0, *)
class FloorPlanView: UIView {
    
    var floorPlanData: FloorPlanData?
    private var currentScale: CGFloat = 1.0
    private var currentTranslation: CGPoint = .zero
    
    init(frame: CGRect, floorPlanData: FloorPlanData) {
        self.floorPlanData = floorPlanData
        super.init(frame: frame)
        self.backgroundColor = .clear
        addGestureRecognizers()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addGestureRecognizers() {
        // Add pinch gesture recognizer for zoom
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(_:)))
        self.addGestureRecognizer(pinchGesture)
        
        // Add pan gesture recognizer for panning
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        self.addGestureRecognizer(panGesture)
    }
    
    @objc private func handlePinchGesture(_ gesture: UIPinchGestureRecognizer) {
        switch gesture.state {
        case .began, .changed:
            let scale = gesture.scale
            currentScale *= scale
            gesture.scale = 1.0
            setNeedsDisplay()
        default:
            break
        }
    }
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began, .changed:
            let translation = gesture.translation(in: self)
            currentTranslation.x += translation.x
            currentTranslation.y += translation.y
            gesture.setTranslation(.zero, in: self)
            setNeedsDisplay()
        default:
            break
        }
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext(), let floorPlanData = floorPlanData else {
            return
        }

        // Apply the current scale and translation to the context
        context.saveGState()
        context.translateBy(x: currentTranslation.x, y: currentTranslation.y)
        context.scaleBy(x: currentScale, y: currentScale)
        
        // Set up drawing parameters
        context.setStrokeColor(UIColor.black.cgColor)
        context.setLineWidth(5.0)

        // Draw walls
        for object in floorPlanData.objects where object.objectType == .wall {
            drawObject(object, in: context)
        }

        // Draw windows
        for object in floorPlanData.objects where object.objectType == .window {
            drawWindow(object, in: context)
        }

        // Draw doors
        for object in floorPlanData.objects where object.objectType == .door {
            drawDoor(object, in: context)
        }

        // Draw other custom elements (like openings)
        context.setStrokeColor(UIColor(red: 0, green: 1, blue: 0, alpha: 0.6).cgColor)
        for object in floorPlanData.objects where object.objectType == .opening {
            drawObject(object, in: context)
        }

        // Reset stroke color to default
        context.setStrokeColor(UIColor.red.cgColor)
        context.setLineWidth(2.0)

        // Draw furniture
        for furniture in floorPlanData.furnitures {
            drawFurniture(furniture, in: context)
        }
        
        // Restore the context to its original state
        context.restoreGState()
    }

    private func drawObject(_ object: FloorPlanObject, in context: CGContext) {
        context.move(to: object.point1)
        context.addLine(to: object.point2)
        context.strokePath()
    }


    
    private func drawFurniture(_ furniture: FurnitureObject, in context: CGContext) {
        guard furniture.points.count == 4 else { return } // Ensure there are exactly 4 points
        
        context.saveGState() // Save the current graphics state
        
        // Draw the rectangle using the points
        let offset:CGPoint = CGPoint(x: 0, y: 0)
        context.move(to: furniture.points[0].applying(CGAffineTransform(translationX: offset.x, y: offset.y)))
        context.addLine(to: furniture.points[2].applying(CGAffineTransform(translationX: offset.x, y: offset.y)))
        context.addLine(to: furniture.points[3].applying(CGAffineTransform(translationX: offset.x, y: offset.y)))
        context.addLine(to: furniture.points[1].applying(CGAffineTransform(translationX: offset.x, y: offset.y)))
        context.closePath()
        context.strokePath()
        
        context.restoreGState() // Restore the graphics state to its previous state
    }
    
    private func drawDoor(_ object: FloorPlanObject, in context: CGContext) {
        let doorSymbol = DoorSymbol(point1: object.point1, point2: object.point2)
        doorSymbol.frame = bounds
        doorSymbol.draw(bounds)
    }
    
    private func drawWindow(_ object: FloorPlanObject, in context: CGContext) {
        let windowSymbol = WindowSymbol(point1: object.point1, point2: object.point2)
        windowSymbol.frame = bounds
        windowSymbol.draw(bounds)
    }
}
