//
//  showPopup.swift
//  GrowingPlants
//
//  Created by haeseongJung on 2022/06/13.
//

import Foundation
import UIKit

class ShowPopup {
    static let shared: ShowPopup = ShowPopup()
    
    func alert(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { action in }
        alert.addAction(okAction)
        return alert
    }
}
