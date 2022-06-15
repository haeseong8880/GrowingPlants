//
//  HomeCollectionViewCell.swift
//  GrowingPlants
//
//  Created by haeseongJung on 2022/06/15.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var plantImageView: UIImageView!
    @IBOutlet weak var plantNameLabel: UILabel!
    @IBOutlet weak var watherSchedule: UILabel!
    @IBOutlet var watherPlanLabels: [UILabel]!
    
    func configure(plant : PlantsEntity) {
        print(plant.plantImageName)
        if let image: UIImage = ImageFileManager.shared.getSavedImage(named: plant.plantImageName) {
            plantImageView.image = image
        }
        plantNameLabel.text = plant.plantName
        let week = plant.waterPlan.components(separatedBy: ",")
        print(week)
    }
}
