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
        return (realm.objects(DiaryEntity.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
    
    func getPlants(reference: Int) -> [DiaryHashable] {
        do {
            let realm = try! Realm()
            let plantsList = realm.objects(DiaryEntity.self).filter("referenceNumber == \(reference)")
            var diaryHash: [DiaryHashable] = []
            for item in plantsList {
                diaryHash.append(DiaryHashable(id: item.id, referenceNumber: item.referenceNumber, diaryImageName: item.diaryImageName, diaryContents: item.diaryContents, registerDate: item.registerDate))
            }
            return diaryHash.reversed()
        } catch {
            print("Error saveUsedHisotry \(error.localizedDescription)")
        }
    }
    
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
    
    func imageUpdate(diaryId: Int, updateImageName: String ,onSuccess: @escaping ((Bool) -> Void)) {
        do {
            let realm = try Realm()
            guard let data = realm.objects(DiaryEntity.self).filter("id == %@", diaryId).first else { return }
            try realm.write{
                data.diaryImageName = updateImageName
            }
            onSuccess(true)
        } catch {
            print("imageUpdate => \(error.localizedDescription)")
        }
    }
    
    func dirayContentUpdate(diaryId: Int, updateContent: String, onSuccess: @escaping((Bool) -> Void)) {
        do {
            let realm = try Realm()
            guard let data = realm.objects(DiaryEntity.self).filter("id == %@", diaryId).first else { return }
            try realm.write{
                data.diaryContents = updateContent
            }
            onSuccess(true)
        } catch {
            print("dirayContentUpdate => \(error.localizedDescription)")
        }
    }
    
    func deleteDiary(diaryId: Int, plantId: Int ,onSuccess: @escaping ((Bool) -> Void)) {
        do {
            let realm = try Realm()
            guard let data = realm.objects(DiaryEntity.self).filter("id == %@ && referenceNumber == %@", diaryId, plantId).first else { return }
            try realm.write {
                realm.delete(data)
            }
            onSuccess(true)
        } catch {
            print("deleteUsedHistory => \(error.localizedDescription)")
        }
    }
    
    func parentsDelete(plantId: Int, onSuccess: @escaping((Bool) -> Void)) {
        do {
            let realm = try Realm()
            let data = realm.objects(DiaryEntity.self).filter("referenceNumber == %@", plantId)
            try realm.write {
                realm.delete(data)
            }
            onSuccess(true)
        } catch {
            print("parentsDelete => \(error.localizedDescription)")
        }
    }
}
