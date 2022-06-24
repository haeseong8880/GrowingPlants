//
//  Utitliy.swift
//  GrowingPlants
//
//  Created by haeseongJung on 2022/06/22.
//

import Foundation
import UIKit

class Utility {
    static let shared: Utility = Utility()
    
    func makeImageName() -> String {
        return "\(ProcessInfo.processInfo.globallyUniqueString).jpeg"
    }
    func cameraEvent() ->UIImagePickerController {
        let camera = UIImagePickerController()
        camera.sourceType = .camera
        camera.allowsEditing = true
        camera.cameraDevice = .rear
        camera.cameraCaptureMode = .photo
//        camera.delegate = self
        return camera
    }
}
