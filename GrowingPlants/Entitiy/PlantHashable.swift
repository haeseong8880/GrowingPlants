//
//  PlantsEntity.swift
//  GrowingPlants
//
//  Created by haeseongJung on 2022/06/15.
//

import Foundation




struct PlantHashable: Hashable {
    let id: Int
    var plantName: String
    let plantImageName: String
    var waterPlan: String
    let registerDate: String
}
