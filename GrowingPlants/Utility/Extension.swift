//
//  Utility.swift
//  GrowingPlants
//
//  Created by haeseongJung on 2022/06/17.
//

import Foundation

extension Date {
    func DateToString() -> String {
        let dateFormatter = DateFormatter()
        //        dateFormatter.dateFormat = "yy-MM-dd HH:mm"
        dateFormatter.dateFormat = "yy-MM-dd"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: self)
    }
}
