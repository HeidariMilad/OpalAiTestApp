import UIKit
import simd

@available(iOS 17.0, *)
public class DoorSymbol: UIView {

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
        
        let WallHeight: CGFloat = 2.0
        let wallColor: UIColor = UIColor.black

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
        if (deltaX >= middleWidth) {
            context.setFillColor(wallColor.cgColor)
            context.fill(CGRect(x: -1, y: -1, width: middleStartX, height: WallHeight))
        }
        
        // Calculate adjusted point2 and control point for the arc
        let adjustedPoint2 = CGPoint(x: middleEndX /*+ (totalLength - middleEndX) / 3*/, y: -middleWidth + 10)
        let controlPoint = CGPoint(x: middleStartX + middleWidth / 3, y: -middleWidth + 10)
        
        // Draw the arc and line using UIBezierPath
        let path = UIBezierPath()
        path.move(to: CGPoint(x: middleStartX - 2, y: 0))
        path.addQuadCurve(to: adjustedPoint2, controlPoint: controlPoint)
        path.addLine(to: CGPoint(x: middleEndX, y: 0))
        
        UIColor.clear.setFill()
        path.fill()
        wallColor.setStroke()
        path.lineWidth = 2
        path.stroke()

        // Draw the right rectangle
        if (deltaX >= middleWidth) {
            context.setFillColor(wallColor.cgColor)
            context.fill(CGRect(x: middleEndX - 1, y: -1, width: totalLength - middleEndX, height: WallHeight))
        }
        
        context.restoreGState()
    }
}

