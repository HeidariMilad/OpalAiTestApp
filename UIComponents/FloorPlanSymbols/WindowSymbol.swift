//
//  WindowSymbol.swift
//  UIComponents
//
//  Created by Milad on 7/16/24.
//

import UIKit
import simd

public class WindowSymbol: UIView {

    var point1: CGPoint = .zero
    var point2: CGPoint = .zero

    // Custom initializer
    public init(point1: CGPoint, point2: CGPoint) {
        self.point1 = point1
        self.point2 = point2
        super.init(frame: CGRect.zero)
        self.backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        // Define the fixed size of the middle shape
        let middleWidth: CGFloat = 30.0
        let middleHeight: CGFloat = 10.0
        
        let WallHeight: CGFloat = 5.0
        let wallColor: UIColor = UIColor.white

        // Calculate the angle and length between point1 and point2
        let deltaX = point2.x - point1.x
        let deltaY = point2.y - point1.y
        let angle = atan2(deltaY, deltaX)
        let totalLength = hypot(deltaX, deltaY)
                
        
        // Calculate the start and end of the middle shape
        let middleStartX = (totalLength - middleWidth) / 2
        let middleEndX = middleStartX + middleWidth

        context.saveGState()
        
        // Move the context to point1 and rotate it to align with point2
        context.translateBy(x: point1.x, y: point1.y)
        context.rotate(by: angle)
        
        // Draw the left rectangle
            context.setFillColor(wallColor.cgColor)
            context.fill(CGRect(x: 0, y: -WallHeight/2, width: middleStartX, height: WallHeight))
        
        
        // Draw the line
        context.setFillColor(wallColor.cgColor)
        context.fill(CGRect(x: middleStartX, y: 0, width: middleWidth, height: 2))

        // Draw the right rectangle
            context.setFillColor(wallColor.cgColor)
            context.fill(CGRect(x: middleEndX - 1, y: -WallHeight/2, width: totalLength - middleEndX, height: WallHeight))
        
        
        context.restoreGState()
    }
}
