//
//  Platform.swift
//  GrowingPlants
//
//  Created by haeseongJung on 2022/06/17.
//

import Foundation

import Foundation

// 시뮬레이터 체크
struct Platform {

    static var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0
    }

}
