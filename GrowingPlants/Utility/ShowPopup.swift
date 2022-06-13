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
    
    func confirm(title: String) -> UIAlertController {
        let alert = UIAlertController(title: nil, message: title, preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "네", style: .default) { _ in
           // 액션 설정
        }
        alert.addAction(yesAction)
        let noAction = UIAlertAction(title: "아니오", style: .cancel) { _ in }
        alert.addAction(noAction)
        return alert
    }
}
