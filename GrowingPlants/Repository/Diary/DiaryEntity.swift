//
//  DiaryEntity.swift
//  GrowingPlants
//
//  Created by haeseongJung on 2022/06/21.
//

import Foundation
import RealmSwift

class DiaryEntity: Object {
    @Persisted var id: Int = 0
    @Persisted var referenceNumber = 0
    @Persisted var diaryImageName: String = ""
    @Persisted var diaryContents: String = ""
    @Persisted var registerDate: String = ""
    // id 가 고유 값입니다.
    override static func primaryKey() -> String? {
        return "id"
    }
}
