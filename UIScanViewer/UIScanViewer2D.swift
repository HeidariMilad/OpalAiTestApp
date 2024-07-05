//
//  UIScanViewer2D.swift
//  UIScanViewer
//
//  Created by Milad on 7/5/24.
//

import UIKit

public class ScanViewer2D: UIView {

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup(){
        self.backgroundColor = UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 1)
    }
}
