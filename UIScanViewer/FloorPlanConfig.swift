//
//  FloorPlanConfig.swift
//  UIScanViewer
//
//  Created by Milad on 7/13/24.
//

import Foundation
import UIKit

class FloorPlanConfig {
    private init() {}

    static var showMetricUnits = true

#if targetEnvironment(macCatalyst)
    static let sizeMultiplier = Double(100)
    static let containerPadding = CGFloat(100)
    static let sectionFont = UIFont.systemFont(ofSize: 15, weight: .heavy)

    static let measurementsThickness = CGFloat(2)
    static let measurementsPadding = CGFloat(16)
    static let measurementsFont = UIFont.systemFont(ofSize: 15, weight: .bold)
    static let maxBounceInViewer = CGFloat(100)
#else
    static let sizeMultiplier = Double(50)
    static let containerPadding = CGFloat(30)
    static let sectionFont = UIFont.systemFont(ofSize: 13, weight: .regular)

    static let measurementsThickness = CGFloat(1)
    static let measurementsPadding = CGFloat(12)
    static let measurementsFont = UIFont.systemFont(ofSize: 10, weight: .regular)
    static let maxBounceInViewer = CGFloat(100)
#endif
    
    static let backgroundColor = UIColor.white
    static let gridColor = UIColor.clear
    static let wallsColor = UIColor.black
    static let windowsColor = UIColor.white
    static let doorsColor = UIColor.white
    static let openingsColor = UIColor.clear
    static let measurementsColor = UIColor.darkGray
}
