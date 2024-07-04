//
//  ViewController.swift
//  OpalAiTestApp
//
//  Created by Milad on 7/4/24.
//

import UIKit
import UIComponents

class ViewController: UIViewController, EditBtnDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
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
 

}
