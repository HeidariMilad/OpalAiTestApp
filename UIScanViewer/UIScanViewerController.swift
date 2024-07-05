//
//  UIScanViewerController.swift
//  UIScanViewer
//
//  Created by Milad on 7/5/24.
//

import UIKit
import UIComponents

public class UIScanViewerController: UIViewController {
    
    private var scanViewer3D: ScanViewer3D?
    private var scanViewer2D: ScanViewer2D?
    private var toggleBtn: ToggleButton!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 1)
        addToggleBtn()
        setupScanViewer3D()
        
    }
    
    func addToggleBtn(){
        toggleBtn = ToggleButton(label: .ThreeD)
        toggleBtn.delegate = self
        self.view.addSubview(toggleBtn)
        
        toggleBtn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            toggleBtn.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            toggleBtn.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 32),
            toggleBtn.heightAnchor.constraint(equalToConstant: 40),
            toggleBtn.widthAnchor.constraint(equalToConstant: 40)
            
        ])
    }
    func setupScanViewer3D() {
        scanViewer3D = ScanViewer3D(frame: self.view.bounds)
        scanViewer3D?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(scanViewer3D!)
        self.view.bringSubviewToFront(toggleBtn)
    }
    
    func setupScanViewer2D() {
        scanViewer2D = ScanViewer2D(frame: self.view.bounds)
        scanViewer2D?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(scanViewer2D!)
        self.view.bringSubviewToFront(toggleBtn)
    }
    
    func remove3DViewer(){
        self.scanViewer3D?.cleanUp()
        self.scanViewer3D?.removeFromSuperview()
        self.scanViewer3D = nil
        
    }
    func remove2DViewer(){
        self.scanViewer2D?.removeFromSuperview()
        self.scanViewer2D = nil
    }
    
    func toggleDimension(){
        if self.scanViewer3D != nil {
            remove3DViewer()
            setupScanViewer2D()
        }else if self.scanViewer2D != nil {
         remove2DViewer()
            setupScanViewer3D()
        }
    }
}

extension UIScanViewerController: ToggleButtonDelegate {
    
    public func toggled(state: UIComponents.ToggleButtonCases) {
        toggleDimension()
    }
    
}
