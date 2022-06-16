//
//  PlantsEntity.swift
//  GrowingPlants
//
//  Created by haeseongJung on 2022/06/15.
//

import Foundation
import RealmSwift

class PlantsEntity: Object {
    @Persisted var id: Int = 0
    @Persisted var plantName: String = ""
    @Persisted var plantImageName: String = ""
    @Persisted var waterPlan: String = ""
    
    // id 가 고유 값입니다.
    override static func primaryKey() -> String? {
        return "id"
    }
}

struct plantHashable: Hashable {
    let id: Int
    let plantName: String
    let plantImageName: String
    let waterPlan: String
}
