//
//  MyPlantDiaryViewController.swift
//  GrowingPlants
//
//  Created by haeseongJung on 2022/06/19.
//

import UIKit

class MyPlantDiaryViewController: UIViewController {

    var palntInfo: PlantHashable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "\(palntInfo?.plantName ?? "")의 반려식물 일기"
    }
    
    @IBAction func registerDiary(_ sender: Any) {
        let storyboard = UIStoryboard(name: "RegisterDiary", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RegisterDiaryViewController") as! RegisterDiaryViewController
//        vc.delegate = self
        present(vc, animated: true)
    }
}
