//
//  UIScanViewer2D.swift
//  UIScanViewer
//
//  Created by Milad on 7/5/24.
//

import UIKit
import RoomPlan
import RealityKit


@available(iOS 17.0, *)
public class ScanViewer2D: UIView {

    var floorPlanView: FloorPlanView!
    
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
        
        guard let capturedRoom = loadAndParseSampleJSON() else { return }
        let floorPlanData = FloorPlanData(with: capturedRoom)
        
        floorPlanView = FloorPlanView(frame: self.bounds, floorPlanData: floorPlanData)
        self.addSubview(floorPlanView)
        
    }
    
    func loadAndParseSampleJSON() -> CapturedRoom? {
        do {
            guard let filePath = Bundle.main.path(forResource: "sample", ofType: "json") else {
                print("Error: sample.json not found")
                return nil
            }
            
            let jsonData = try Data(contentsOf: URL(fileURLWithPath: filePath))
            
            let decoder = JSONDecoder()
            let roomData = try decoder.decode(CapturedRoom.self, from: jsonData)
            
            return roomData
        } catch {
            print("Error loading or decoding JSON: \(error)")
            return nil
        }
    }
    
//    let encoder = JSONEncoder()
//    do {
//        let jsonData = try encoder.encode(finalResults)
//        let jsonString = String(data: jsonData, encoding: .utf8)
//        print(jsonString)
//    } catch {
//        print("Error encoding object to JSON: \(error.localizedDescription)")
//    }
    

//    func exportToUSDZ(capturedRoom: CapturedRoom, url: URL) {
//        do {
//            let anchorEntity = try Experience.loadCapturedRoom(capturedRoom)
//            try anchorEntity.saveUSDZ(to: url)
//            print("Exported CapturedRoom to USDZ file successfully.")
//        } catch {
//            print("Error exporting CapturedRoom to USDZ file: \(error.localizedDescription)")
//        }
//    }
    
//    func exportToUSDZ(){
//        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//        let fileURL = documentsPath.appendingPathComponent("exportedRoom.usdz")
//    }
}
