//
//  ViewController.swift
//  OpalAiTestApp
//
//  Created by Milad on 7/4/24.
//

import UIKit
import UIComponents

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    
    }
    

}

//class MainViewController: UIViewController, UISheetPresentationControllerDelegate {
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 1)
//        
//        let presentButton = UIButton(type: .system)
//        presentButton.setTitle("Present Sheet", for: .normal)
//        presentButton.addTarget(self, action: #selector(presentSheet), for: .touchUpInside)
//        
//        presentButton.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(presentButton)
//        
//        NSLayoutConstraint.activate([
//            presentButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            presentButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//        ])
//    }
//    var coder: NSCoder!
//    required init?(coder: NSCoder) {
//        self.coder = coder
//        super.init(coder: coder)
//    }
//    @objc func presentSheet() {
//        guard let draggableVC = DraggableViewController(coder: self.coder) else { fatalError() }
//          draggableVC.modalPresentationStyle = .pageSheet
//          
//          if let sheet = draggableVC.sheetPresentationController {
//              let smallDetent = UISheetPresentationController.Detent.custom { context in
//                  return 40
//              }
//              let mediumDetent = UISheetPresentationController.Detent.custom { context in
//                  return self.view.bounds.height / 3
//              }
//              
//              sheet.detents = [smallDetent, mediumDetent, .large()]
//              sheet.prefersGrabberVisible = true
//              sheet.largestUndimmedDetentIdentifier = mediumDetent.identifier
//              sheet.delegate = self
//          }
//          
//          present(draggableVC, animated: true, completion: nil)
//      }
//    
//    // MARK: - UISheetPresentationControllerDelegate
//    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
//        return false
//    }
//    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
//        // Handle dismissal if necessary
//    }
//    func sheetPresentationControllerDidChangeSelectedDetentIdentifier(_ sheetPresentationController: UISheetPresentationController) {
//        guard let detentIdentifier = sheetPresentationController.selectedDetentIdentifier else { return }
//        
//        // Perform animations based on detentIdentifier
//        UIView.animate(withDuration: 0.3) {
//            if detentIdentifier == UISheetPresentationController.Detent.Identifier.medium {
//                // Update constraints for medium detent
//                self.updateConstraintsForMediumDetent()
//            } else if detentIdentifier == UISheetPresentationController.Detent.Identifier.large {
//                // Update constraints for large detent
//                self.updateConstraintsForLargeDetent()
//            } else {
//                // Update constraints for small detent
//                self.updateConstraintsForSmallDetent()
//            }
//            self.view.layoutIfNeeded()
//        }
//    }
//
//        func updateConstraintsForSmallDetent() {
//            // Update your constraints for small detent
//        }
//
//        func updateConstraintsForMediumDetent() {
//            // Update your constraints for medium detent
//        }
//
//        func updateConstraintsForLargeDetent() {
//            // Update your constraints for large detent
//        }
//    
//}





class FloorPlanView: UIView {
    var welcome: Welcome?

    init(frame: CGRect, welcome: Welcome) {
        self.welcome = welcome
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        guard let welcome = welcome else { return }

        // Render walls
        for wall in welcome.walls {
            let wallView = WallView(wall: wall)
            addSubview(wallView)
        }

        // Render doors
        for door in welcome.doors {
            let doorView = DoorView(door: door)
            addSubview(doorView)
        }

        // Render windows
        for window in welcome.windows {
            let windowView = WindowView(window: window)
            addSubview(windowView)
        }

        // Render openings
        for opening in welcome.openings {
            let openingView = OpeningView(opening: opening)
            addSubview(openingView)
        }

        // Render objects
        for object in welcome.objects {
            let objectView = ObjectView(object: object)
            addSubview(objectView)
        }
    }
}

class WallView: UIView {
    init(wall: Wall) {
        let width = CGFloat(wall.dimensions[0])
        let height = CGFloat(wall.dimensions[1])
        super.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
        backgroundColor = .gray
        center = CGPoint(x: CGFloat(wall.transform[12]), y: CGFloat(wall.transform[13]))
        transform = CGAffineTransform(rotationAngle: CGFloat(atan2(wall.transform[4], wall.transform[0])))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class DoorView: UIView {
    init(door: DoorElement) {
        let width = CGFloat(door.dimensions[0])
        let height = CGFloat(door.dimensions[1])
        super.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
        backgroundColor = .brown
        center = CGPoint(x: CGFloat(door.transform[12]), y: CGFloat(door.transform[13]))
        transform = CGAffineTransform(rotationAngle: CGFloat(atan2(door.transform[4], door.transform[0])))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class WindowView: UIView {
    init(window: Window) {
        let width = CGFloat(window.dimensions[0])
        let height = CGFloat(window.dimensions[1])
        super.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
        backgroundColor = .blue
        center = CGPoint(x: CGFloat(window.transform[12]), y: CGFloat(window.transform[13]))
        transform = CGAffineTransform(rotationAngle: CGFloat(atan2(window.transform[4], window.transform[0])))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class OpeningView: UIView {
    init(opening: Opening) {
        let width = CGFloat(opening.dimensions[0])
        let height = CGFloat(opening.dimensions[1])
        super.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
        backgroundColor = .green
        center = CGPoint(x: CGFloat(opening.transform[12]), y: CGFloat(opening.transform[13]))
        transform = CGAffineTransform(rotationAngle: CGFloat(atan2(opening.transform[4], opening.transform[0])))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ObjectView: UIView {
    init(object: Object) {
        let width = CGFloat(object.dimensions[0])
        let height = CGFloat(object.dimensions[1])
        super.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
        backgroundColor = .purple
        center = CGPoint(x: CGFloat(object.transform[12]), y: CGFloat(object.transform[13]))
        transform = CGAffineTransform(rotationAngle: CGFloat(atan2(object.transform[4], object.transform[0])))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



class TwoDViewController: UIViewController, UIScrollViewDelegate {
    var scrollView: UIScrollView!
    var floorPlanView: FloorPlanView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Parse the JSON to get the floor plan data
        guard let welcome = parseJSON() else { return }

        // Setup the scroll view
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.5
        scrollView.maximumZoomScale = 50.0
        view.addSubview(scrollView)

        // Setup the floor plan view
        floorPlanView = FloorPlanView(frame: view.bounds, welcome: welcome)
        scrollView.addSubview(floorPlanView)
        scrollView.contentSize = floorPlanView.bounds.size

        // Add gesture recognizers for rotation and panning
        let rotationGestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(handleRotation(_:)))
        scrollView.addGestureRecognizer(rotationGestureRecognizer)

        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        scrollView.addGestureRecognizer(panGestureRecognizer)
    }

    // UIScrollViewDelegate method
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return floorPlanView
    }

    @objc func handleRotation(_ gestureRecognizer: UIRotationGestureRecognizer) {
        if let view = gestureRecognizer.view {
            view.transform = view.transform.rotated(by: gestureRecognizer.rotation)
            gestureRecognizer.rotation = 0
        }
    }

    @objc func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: gestureRecognizer.view)
        if let view = gestureRecognizer.view {
            view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
            gestureRecognizer.setTranslation(CGPoint.zero, in: view)
        }
    }

    // Function to parse the JSON file
    func parseJSON() -> Welcome? {
        let url = Bundle.main.url(forResource: "sample", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        let decoder = JSONDecoder()
        do {
            let welcome = try decoder.decode(Welcome.self, from: data)
            return welcome
        } catch {
            print("Error decoding JSON: \(error)")
            return nil
        }
    }
}
