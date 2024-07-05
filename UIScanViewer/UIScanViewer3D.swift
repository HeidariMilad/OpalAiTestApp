//
//  UIScanViewer3D.swift
//  UIScanViewer
//
//  Created by Milad on 7/5/24.
//

import UIKit
import SceneKit

public class UIScanViewer3D: UIViewController {
    var sceneView: SCNView!
    var modelNode: SCNNode!

    override public func viewDidLoad() {
        super.viewDidLoad()
        setupSceneView()
        loadUSDZModel()
        //setupGestures()
    }

    func setupSceneView() {
        sceneView = SCNView(frame: self.view.frame)
        sceneView.allowsCameraControl = true
        sceneView.autoenablesDefaultLighting = true
        self.view.addSubview(sceneView)
    }

    func loadUSDZModel() {
        guard let url = Bundle(for: type(of: self)).url(forResource: "sample", withExtension: "usdz") else {
            fatalError("Failed to find USDZ file in the bundle")
        }
        
        guard let scene = try? SCNScene(url: url) else {
            fatalError("Failed to load USDZ model")
        }
        
        sceneView.scene = scene
        modelNode = scene.rootNode.childNodes.first
    }

    func setupGestures() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(_:)))
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTapGesture(_:)))
        
        doubleTapGesture.numberOfTapsRequired = 2

        self.view.addGestureRecognizer(panGesture)
        self.view.addGestureRecognizer(pinchGesture)
        self.view.addGestureRecognizer(doubleTapGesture)
    }

    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: gesture.view)
        let x = Float(translation.x) * 0.01
        let y = Float(-translation.y) * 0.01
        modelNode.eulerAngles.x += x
        modelNode.eulerAngles.y += y
        gesture.setTranslation(.zero, in: gesture.view)
    }

    @objc func handlePinchGesture(_ gesture: UIPinchGestureRecognizer) {
        let scale = Float(gesture.scale)
        modelNode.scale = SCNVector3(scale, scale, scale)
        gesture.scale = 1.0
    }

    @objc func handleDoubleTapGesture(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: sceneView)
        let hitResults = sceneView.hitTest(location, options: nil)
        if let result = hitResults.first {
            let hitNode = result.node
            let hitPosition = result.worldCoordinates

            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            hitNode.position = hitPosition
            modelNode.eulerAngles = SCNVector3Zero
            SCNTransaction.commit()
        }
    }
}

