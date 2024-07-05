//
//  DescriptionView.swift
//  UIComponents
//
//  Created by Milad on 7/6/24.
//

import UIKit

open class DescriptionView: UIView {
    
    public var title: UILabel!
    public var subTitle: UILabel?
    
    public init(title: String, subTitle: String? = "") {
        super.init(frame: .zero)
        self.title = UILabel(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        self.subTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        self.title.text = title
        self.subTitle?.text = subTitle
        
        setupLayout()
    }
    
    public func updateDescription(title: String, subTitle: String? = ""){
        self.title.text = title
        self.subTitle?.text = subTitle
    }
    func setupLayout(){
        self.title.font = .systemFont(ofSize: 12, weight: .semibold)
        self.title.textAlignment = .center
        self.title.textColor = .black
        self.subTitle?.font = .systemFont(ofSize: 12, weight: .thin)
        self.subTitle?.textAlignment = .center
        self.subTitle?.textColor = .gray
        
        self.title.translatesAutoresizingMaskIntoConstraints = false
        self.subTitle?.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(self.title)
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: self.topAnchor),
            title.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            title.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            title.heightAnchor.constraint(equalToConstant: 15)
        ])
        
        if let subtitle = self.subTitle {
            self.addSubview(subtitle)
            NSLayoutConstraint.activate([
                subtitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 2),
                subtitle.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                subtitle.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                subtitle.heightAnchor.constraint(equalToConstant: 15),
                subtitle.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
        }
        
        
        
    }
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
