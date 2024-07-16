//
//  UIScanViewer3D.swift
//  UIScanViewer
//
//  Created by Milad on 7/5/24.
//

import UIKit
import SceneKit

public class ScanViewer3D: UIView {
    var sceneView: SCNView!
    var modelNode: SCNNode!

    override init(frame: CGRect) {
        super.init(frame: frame)
        //setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //setup()
    }
    init(frame: CGRect, filePath: URL?) {
        super.init(frame: frame)
        setup(url: filePath)
    }

    public func cleanUp(){
        self.modelNode.removeFromParentNode()
        self.modelNode = nil
        self.sceneView.removeFromSuperview()
        self.sceneView.scene = nil
        self.sceneView = nil
    }
    func setup(url: URL?){
        setupSceneView()
        loadUSDZModel(url: url)
        //setupGestures()
    }
    func setupSceneView() {
            self.sceneView = SCNView(frame: self.bounds)
            self.sceneView.allowsCameraControl = true
            self.sceneView.autoenablesDefaultLighting = true
            self.sceneView.backgroundColor = .clear
            self.addSubview(self.sceneView)
            self.backgroundColor = .clear
    }

    
    func loadUSDZModel(url: URL?) {
        guard let url = url else {
            fatalError("Failed to find USDZ file in the bundle")
        }
        
        guard let scene = try? SCNScene(url: url) else {
            fatalError("Failed to load USDZ model")
        }
        
        self.sceneView.scene = scene
        self.modelNode = scene.rootNode.childNodes.first
    }

    func setupGestures() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(_:)))
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTapGesture(_:)))
        
        doubleTapGesture.numberOfTapsRequired = 2

        self.addGestureRecognizer(panGesture)
        self.addGestureRecognizer(pinchGesture)
        self.addGestureRecognizer(doubleTapGesture)
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
