//
//  PlantsRealm.swift
//  GrowingPlants
//
//  Created by haeseongJung on 2022/06/13.
//

import Foundation
import RealmSwift

class PlantsRealm {
    static let shared: PlantsRealm = PlantsRealm()
    
    
    private func autoIncrementID() -> Int {
        let realm = try! Realm()
        return (realm.objects(PlantsEntity.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
    
    func getPlants() -> [PlantsEntity] {
        do {
            let realm = try! Realm()
            let plantsList = realm.objects(PlantsEntity.self)
            return Array(plantsList)
        } catch {
            print("Error saveUsedHisotry \(error.localizedDescription)")
        }
    }
    
    func savePlant(plant: PlantsEntity, onSuccess: @escaping ((Bool) -> Void)) {
        do {
            let realm = try Realm()
            plant.id = autoIncrementID()
            try realm.write{
                realm.add(plant)
            }
            onSuccess(true)
        } catch {
            print("savePlant => \(error.localizedDescription)")
        }
    }
    //
    //        func deleteUsedHistory(history: UsedHistoryModel, onSuccess: @escaping ((Bool) -> Void)) {
    //            do {
    //                let realm = try! Realm()
    //                guard let data = realm.objects(UsedHistoryModel.self).filter("id == %@", history.id).first else { return }
    //                try realm.write {
    //                    realm.delete(data)
    //                }
    //                onSuccess(true)
    //            } catch {
    //                print("deleteUsedHistory => \(error.localizedDescription)")
    //            }
    //        }
    //
    //        func updateHistory(history: UsedHistoryModel, updateData: String ,type: SwipeActionEnum, onSuccess: @escaping ((Bool) -> Void)) {
    //            do {
    //                let realm = try! Realm()
    //                guard let data = realm.objects(UsedHistoryModel.self).filter("id == %@", history.id).first else { return }
    //                print(data)
    //                onSuccess(true)
    //            } catch {
    //                print("updateMember => \(error.localizedDescription)")
    //            }
    //        }
}
