//
//  TitleLabel.swift
//  UIComponents
//
//  Created by Milad on 7/4/24.
//

import UIKit

public protocol EditBtnDelegate {
    func editBtnTapped()
}

open class TitleLabel: UIView {

    var title: String!
    public var delegate: EditBtnDelegate?
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    public init(title: String) {
        super.init(frame: .zero)
        self.title = title
        setupLabel()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLabel() {
        let label = UILabel(frame: self.frame)
        self.addSubview(label)
        label.text = self.title
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textAlignment = .center
        
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        // ---
        let editBtn = UIButton(type: .system)
        editBtn.frame = CGRect(x: 0, y: 0, width: 16, height: 16)
        let bundle = Bundle(for: TitleLabel.self)
        let image = UIImage(named: "Edit", in: bundle, with: nil)
        editBtn.setImage(image, for: .normal)
        
        self.addSubview(editBtn)
        
        editBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            editBtn.widthAnchor.constraint(equalToConstant: 32),
            editBtn.heightAnchor.constraint(equalToConstant: 32),
            editBtn.trailingAnchor.constraint(equalTo: label.leadingAnchor, constant: 0),
            editBtn.centerYAnchor.constraint(equalTo: label.centerYAnchor)
            
        ])
        
        // Enable user interaction
        editBtn.isUserInteractionEnabled = true
        self.isUserInteractionEnabled = true
        
        // Add target for the button tap action
        editBtn.addTarget(self, action: #selector(editBtnTapped), for: .touchUpInside)
        
    }
    
    @objc func editBtnTapped() {
        delegate?.editBtnTapped()
    }
}
