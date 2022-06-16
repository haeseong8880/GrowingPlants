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
        if let image: UIImage = ImageFileManager.shared.getSavedImage(named: plant.plantImageName) {
            plantImageView.image = image
        }
        plantNameLabel.text = plant.plantName
        let week = plant.waterPlan.components(separatedBy: ",")
        week.forEach {
            watherPlanLabels[Int($0)! - 1].backgroundColor = #colorLiteral(red: 0.8941176471, green: 0.7490196078, blue: 0.7019607843, alpha: 1)
        }
        imageViewConfigure()
    }
    
    private func imageViewConfigure() {
        plantImageView.layer.cornerRadius = 10
    }
}
