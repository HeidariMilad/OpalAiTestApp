//
//  ToggleButton.swift
//  UIComponents
//
//  Created by Milad on 7/4/24.
//

import UIKit

public protocol ToggleButtonDelegate {
    func toggled(state: ToggleButtonCases)
}

public enum ToggleButtonCases: String {
    case TwoD = "2D"
    case ThreeD = "3D"
}

public class ToggleButton: UIView {

    
    public var delegate: ToggleButtonDelegate?
    var label: ToggleButtonCases = .TwoD
    var button: UIButton!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    public init(label: ToggleButtonCases) {
        super.init(frame: .zero)
        self.label = label
        setupButton()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupButton() {
        let btn = UIButton(type: .system)
        self.button = btn
        var config = UIButton.Configuration.plain()
        
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 1, bottom: 0, trailing: 1)
        config.imagePadding = 2
        btn.semanticContentAttribute = .forceRightToLeft
        config.baseForegroundColor = .black //UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1.0)
        
        setTitle()
        btn.configuration = config
        
        btn.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        
        let bundle = Bundle(for: ToggleButton.self)
        var image = UIImage(named: "Vector", in: bundle, with: nil)
        image = image?.withTintColor(UIColor.systemGray2)
        btn.setImage(image, for: .normal)
        
        btn.layer.borderWidth = 1.0
        btn.layer.borderColor = UIColor.white.cgColor
        btn.layer.cornerRadius = 6.0

        btn.backgroundColor = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 0.64)
        
        
        self.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            button.widthAnchor.constraint(equalTo: self.widthAnchor),
            button.heightAnchor.constraint(equalTo: self.heightAnchor)
        ])
        
        // Enable user interaction
        btn.isUserInteractionEnabled = true
        self.isUserInteractionEnabled = true
        
        // Add target for the button tap action
        btn.addTarget(self, action: #selector(toggleBtnTapped), for: .touchUpInside)
    }
    
    func setTitle(){
        let attributedTitle = NSAttributedString(string: label.rawValue, attributes: [
            .font: UIFont.systemFont(ofSize: 12),
            
        ])
        self.button.setAttributedTitle(attributedTitle, for: .normal)
    }
    
    @objc func toggleBtnTapped() {
        
        if self.label == .TwoD {
            self.label = .ThreeD
        }else{
            self.label = .TwoD
        }
        self.setTitle()
        self.delegate?.toggled(state: self.label)
    }
     
}
