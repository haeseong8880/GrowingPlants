//
//  DiaryHashable.swift
//  GrowingPlants
//
//  Created by haeseongJung on 2022/06/23.
//

import Foundation

struct DiaryHashable: Hashable {
    let id: Int
    let referenceNumber: Int
    let diaryImageName: String
    let diaryContents: String
    let registerDate: String
}
