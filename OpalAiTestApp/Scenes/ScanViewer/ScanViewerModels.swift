//
//  ScanViewerModels.swift
//  OpalAiTestApp
//
//  Created by Milad on 7/4/24.
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import RoomPlan

enum ScanViewer
{
  // MARK: Use cases
  
  enum PlanModel
  {
    struct Request
    {
    }
    struct Response
    {
        var plan2D: CapturedRoom?
        var plan3D: URL?
        var sample3D: URL?
        
    }
    struct ViewModel
    {
        var plan2D: CapturedRoom?
        var plan3D: URL?
        var sample3D: URL?
    }
  }
}
