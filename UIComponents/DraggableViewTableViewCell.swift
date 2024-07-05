//
//  DraggableViewTableViewCell.swift
//  UIComponents
//
//  Created by Milad on 7/5/24.
//

import UIKit


public class DraggableViewTableViewCell: UITableViewCell {

    let customImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        imageView.layer.cornerRadius = 6
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1)
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        contentView.addSubview(customImageView)
        
        NSLayoutConstraint.activate([
            customImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            customImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        contentView.bringSubviewToFront(customImageView)
    }
    
    public func configureCell(text: String, secondaryText: String, imageName: String) {
        var content = defaultContentConfiguration()
        content.text = text
        content.secondaryText = secondaryText
        let bundle = Bundle(for: DraggableViewTableViewCell.self)
        let image = UIImage(named: imageName, in: bundle, with: nil)
        content.image = image //nil // Remove the default image
        
        contentConfiguration = content
        //customImageView.image = UIImage(systemName: "info.circle") // Placeholder image, replace with actual images
        
    }
}
