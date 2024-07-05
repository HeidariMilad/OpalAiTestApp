//
//  UIScanViewerController.swift
//  UIScanViewer
//
//  Created by Milad on 7/5/24.
//

import UIKit
import UIComponents

public class UIScanViewerController: UIViewController {
    
    public var alertPresenter: UIViewController?
    private var scanViewer3D: ScanViewer3D?
    private var scanViewer2D: ScanViewer2D?
    private var toggleBtn: ToggleButton!
    private var titleLabel: TitleLabel!
    private var descriptionText: DescriptionView!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 1)
        addToggleBtn()
        addTitleLabel()
        addDescriptionText()
        setupScanViewer3D()
        
    }
    
    func addDescriptionText(){
        descriptionText = DescriptionView(title: "3D Floor Title", subTitle: "136K vertices, 212K faces")
        
        self.view.addSubview(descriptionText)
        descriptionText.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            descriptionText.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            descriptionText.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -60),
            descriptionText.heightAnchor.constraint(equalToConstant: 35),
            descriptionText.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
    func addToggleBtn(){
        toggleBtn = ToggleButton(label: .ThreeD)
        toggleBtn.delegate = self
        self.view.addSubview(toggleBtn)
        
        toggleBtn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            toggleBtn.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            toggleBtn.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 60),
            toggleBtn.heightAnchor.constraint(equalToConstant: 40),
            toggleBtn.widthAnchor.constraint(equalToConstant: 40)
            
        ])
    }
    func setupScanViewer3D() {
        scanViewer3D = ScanViewer3D(frame: self.view.bounds)
        scanViewer3D?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        descriptionText.updateDescription(title: "3D Floor Title", subTitle: "136K vertices, 212K faces")
        
        self.view.addSubview(scanViewer3D!)
        self.view.bringSubviewToFront(toggleBtn)
        self.view.bringSubviewToFront(titleLabel)
        self.view.bringSubviewToFront(descriptionText)
    }
    
    func setupScanViewer2D() {
        scanViewer2D = ScanViewer2D(frame: self.view.bounds)
        scanViewer2D?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        descriptionText.updateDescription(title: "2D Floor Title")
        
        self.view.addSubview(scanViewer2D!)
        self.view.bringSubviewToFront(toggleBtn)
        self.view.bringSubviewToFront(titleLabel)
        self.view.bringSubviewToFront(descriptionText)
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

extension UIScanViewerController: EditBtnDelegate {
    func addTitleLabel(){
        titleLabel = TitleLabel(title: "OpalAiTest")
        titleLabel.delegate = self
        self.view.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // label in top center of view
            titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
            titleLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor)
            
        ])
    }
    public func editBtnTapped() {
        // Create an alert controller
        let alertController = UIAlertController(title: "Rename Project", message: "Enter the new project name", preferredStyle: .alert)
        
        // Add a text field to the alert controller
        alertController.addTextField { textField in
            textField.placeholder = "New project name"
        }
        
        // Add a cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // Add a rename action
        let renameAction = UIAlertAction(title: "Rename", style: .default) { [weak self] _ in
            if let newName = alertController.textFields?.first?.text {
                self?.renameProject(to: newName)
            }
        }
        alertController.addAction(renameAction)
        
        // Present the alert controller
        alertPresenter?.present(alertController, animated: true, completion: nil)
    }
 
    func renameProject(to newName: String) {
        // Implement your project renaming logic here
        titleLabel.changeTitle(text: newName)
    }
}
