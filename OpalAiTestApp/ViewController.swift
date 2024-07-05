//
//  ViewController.swift
//  OpalAiTestApp
//
//  Created by Milad on 7/4/24.
//

import UIKit
import UIComponents

class ViewController: UIViewController, EditBtnDelegate, ToggleButtonDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        addToggleBtn()
    
    }
    
    func addToggleBtn(){
        let toggle = ToggleButton(label: .ThreeD)
        toggle.delegate = self
        self.view.addSubview(toggle)
        
        toggle.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // label in top center of view
            toggle.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            toggle.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 32),
            toggle.heightAnchor.constraint(equalToConstant: 40),
            toggle.widthAnchor.constraint(equalToConstant: 40)
            
        ])
    }
    func addTitleLabel(){
        let label = TitleLabel(title: "First Edition map")
        label.delegate = self
        self.view.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // label in top center of view
            label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            label.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            label.heightAnchor.constraint(equalToConstant: 40),
            label.widthAnchor.constraint(equalTo: self.view.widthAnchor)
            
        ])
    }
    func editBtnTapped() {
        print("Edit Tapped")
    }
 
    func toggled(state: ToggleButtonCases) {
        print("Toggled to: ", state.rawValue)
    }

}

class MainViewController: UIViewController, UISheetPresentationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 1)
        
        let presentButton = UIButton(type: .system)
        presentButton.setTitle("Present Sheet", for: .normal)
        presentButton.addTarget(self, action: #selector(presentSheet), for: .touchUpInside)
        
        presentButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(presentButton)
        
        NSLayoutConstraint.activate([
            presentButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            presentButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    var coder: NSCoder!
    required init?(coder: NSCoder) {
        self.coder = coder
        super.init(coder: coder)
    }
    @objc func presentSheet() {
        guard let draggableVC = DraggableViewController(coder: self.coder) else { fatalError() }
          draggableVC.modalPresentationStyle = .pageSheet
          
          if let sheet = draggableVC.sheetPresentationController {
              let smallDetent = UISheetPresentationController.Detent.custom { context in
                  return 40
              }
              let mediumDetent = UISheetPresentationController.Detent.custom { context in
                  return self.view.bounds.height / 3
              }
              
              sheet.detents = [smallDetent, mediumDetent, .large()]
              sheet.prefersGrabberVisible = true
              sheet.largestUndimmedDetentIdentifier = mediumDetent.identifier
              sheet.delegate = self
          }
          
          present(draggableVC, animated: true, completion: nil)
      }
    
    // MARK: - UISheetPresentationControllerDelegate
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        return false
    }
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        // Handle dismissal if necessary
    }
}





