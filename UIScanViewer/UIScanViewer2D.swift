//
//  UIScanViewer2D.swift
//  UIScanViewer
//
//  Created by Milad on 7/5/24.
//

import UIKit
import RoomPlan


@available(iOS 17.0, *)
public class ScanViewer2D: UIView {

    var floorPlanView: FloorPlanView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //setup()
        
    }
    
    public init(frame: CGRect, plan2D: CapturedRoom?) {
        super.init(frame: frame)
        setup(plan2D: plan2D)
    }
    
    func setup(plan2D: CapturedRoom?){
        self.backgroundColor = UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 1)
        
        guard let capturedRoom = plan2D else { return }
        let floorPlanData = FloorPlanData(with: capturedRoom)
        
        floorPlanView = FloorPlanView(frame: self.bounds, floorPlanData: floorPlanData)
        self.addSubview(floorPlanView)
        
        
    }
    
//    func loadAndParseSampleJSON() -> CapturedRoom? {
//        do {
//            guard let filePath = Bundle.main.path(forResource: "sample", ofType: "json") else {
//                print("Error: sample.json not found")
//                return nil
//            }
//            
//            let jsonData = try Data(contentsOf: URL(fileURLWithPath: filePath))
//            
//            let decoder = JSONDecoder()
//            let roomData = try decoder.decode(CapturedRoom.self, from: jsonData)
//            
//            return roomData
//        } catch {
//            print("Error loading or decoding JSON: \(error)")
//            return nil
//        }
//    }
    
}
