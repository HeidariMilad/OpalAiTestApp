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
