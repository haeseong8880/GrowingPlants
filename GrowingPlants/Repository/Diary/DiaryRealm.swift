//
//  DiaryRealm.swift
//  GrowingPlants
//
//  Created by haeseongJung on 2022/06/22.
//

import Foundation
import RealmSwift

class DiaryRealm {
    static let shared: DiaryRealm = DiaryRealm()
    
    
    private func autoIncrementID() -> Int {
        let realm = try! Realm()
        return (realm.objects(PlantsEntity.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
//
//    func getPlants() -> [PlantHashable] {
//        do {
//            let realm = try! Realm()
//            let plantsList = realm.objects(PlantsEntity.self)
//            var plantHash: [PlantHashable] = []
//            for item in plantsList {
//                plantHash.append(PlantHashable(id: item.id, plantName: item.plantName, plantImageName: item.plantImageName, waterPlan: item.waterPlan, registerDate: item.registerDate))
//            }
//            return plantHash
//        } catch {
//            print("Error saveUsedHisotry \(error.localizedDescription)")
//        }
//    }

    func savePlant(diary: DiaryEntity, onSuccess: @escaping ((Bool) -> Void)) {
        do {
            let realm = try Realm()
            diary.id = autoIncrementID()
            try realm.write{
                realm.add(diary)
            }
            onSuccess(true)
        } catch {
            print("savePlant => \(error.localizedDescription)")
        }
    }

//    func deletePlant(plantid: Int, onSuccess: @escaping ((Bool) -> Void)) {
//        do {
//            let realm = try Realm()
//            guard let data = realm.objects(PlantsEntity.self).filter("id == %@", plantid).first else { return }
//            try realm.write {
//                realm.delete(data)
//            }
//            onSuccess(true)
//        } catch {
//            print("deleteUsedHistory => \(error.localizedDescription)")
//        }
//    }
//
//    func updatePlantInfo(plantid: Int, plantInfo: PlantHashable, onSuccess: @escaping ((Bool) -> Void)) {
//        do {
//            let realm = try! Realm()
//            guard let data = realm.objects(PlantsEntity.self).filter("id == %@", plantid).first else { return }
//            try realm.write {
//                data.plantName = plantInfo.plantName
//                data.waterPlan = plantInfo.waterPlan
//            }
//            onSuccess(true)
//        } catch {
//            print("updateMember => \(error.localizedDescription)")
//        }
//    }
    
}
