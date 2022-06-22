//
//  Utitliy.swift
//  GrowingPlants
//
//  Created by haeseongJung on 2022/06/22.
//

import Foundation

class Utility {
    static let shared: Utility = Utility()
    
    func makeImageName() -> String {
        return "\(ProcessInfo.processInfo.globallyUniqueString).jpeg"
    }
}
