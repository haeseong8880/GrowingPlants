//
//  PlantsEntity.swift
//  GrowingPlants
//
//  Created by haeseongJung on 2022/06/21.
//

import Foundation
import RealmSwift

class PlantsEntity: Object {
    @Persisted var id: Int = 0
    @Persisted var plantName: String = ""
    @Persisted var plantImageName: String = ""
    @Persisted var waterPlan: String = ""
    @Persisted var registerDate: String = ""
    // id 가 고유 값입니다.
    override static func primaryKey() -> String? {
        return "id"
    }
}
