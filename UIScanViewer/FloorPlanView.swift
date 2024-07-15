//
//  FloorPlanView.swift
//  UIScanViewer
//
//  Created by Milad on 7/14/24.
//

import UIKit
import simd

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
        context.setLineWidth(2.0)

        // Draw walls
        for object in floorPlanData.objects where object.objectType == .wall {
            drawObject(object, in: context)
        }

        // Draw windows
        context.setStrokeColor(UIColor.blue.cgColor)
        for object in floorPlanData.objects where object.objectType == .window {
            drawObject(object, in: context)
        }

        // Draw doors
        context.setStrokeColor(UIColor.red.cgColor)
        for object in floorPlanData.objects where object.objectType == .door {
            drawObject(object, in: context)
        }

        // Draw other custom elements (like openings)
        context.setStrokeColor(UIColor.green.cgColor)
        for object in floorPlanData.objects where object.objectType == .opening {
            drawObject(object, in: context)
        }

//        // Reset stroke color to default
//        context.setStrokeColor(UIColor.black.cgColor)
//
//        // Draw furniture
//        for furniture in floorPlanData.furnitures {
//            drawFurniture(furniture, in: context)
//        }
        
        // Restore the context to its original state
        context.restoreGState()
    }

    private func drawObject(_ object: FloorPlanObject, in context: CGContext) {
        context.move(to: object.point1)
        context.addLine(to: object.point2)
        context.strokePath()
    }

    private func drawFurniture(_ furniture: FurnitureObject, in context: CGContext) {
        let rect = CGRect(x: furniture.center.x, y: furniture.center.y, width: furniture.width, height: furniture.height)
        context.addRect(rect)
        context.strokePath()
    }
}
