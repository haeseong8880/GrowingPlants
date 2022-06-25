//
//  localNotificationUtility.swift
//  GrowingPlants
//
//  Created by haeseongJung on 2022/06/19.
//

import Foundation
import UIKit

class LocalNotificationUtility {
    static let shared: LocalNotificationUtility = LocalNotificationUtility()
    
    // Local Notificaion Setting
    func localNotificaitionSetting(week: Week, plantName: String, imageName: String) {
        // 푸시에 표시 될 컨텐츠
        let content = UNMutableNotificationContent()
        content.title = "\(plantName)에게 물을 주는 날입니다!"
        content.body = "오늘은 \(week.weekName)요일 입니다."
        
        // 푸시 일정 주기
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        
        dateComponents.weekday = week.tagNumber + 1
        dateComponents.hour = 12
        //        dateComponents.minute = 49
        
        // 트리거 생성
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents, repeats: true)
        
        // Create the request
        let request = UNNotificationRequest(identifier: "\(imageName)_\(week)",
                                            content: content, trigger: trigger)
        // Schedule the request with the system.
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
            if error != nil {
                print("Local Notification Error ====> \(error?.localizedDescription)")
            }
        }
    }

}
