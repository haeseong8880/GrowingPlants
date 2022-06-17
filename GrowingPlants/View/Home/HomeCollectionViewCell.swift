//
//  HomeCollectionViewCell.swift
//  GrowingPlants
//
//  Created by haeseongJung on 2022/06/15.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    
    var plantId: Int?
    var delegate: sendDataDelegate?
    
    @IBOutlet weak var plantImageView: UIImageView!
    @IBOutlet weak var plantNameLabel: UILabel!
    @IBOutlet weak var watherSchedule: UILabel!
    @IBOutlet var watherPlanLabels: [UILabel]!
    @IBOutlet weak var dateLabel: UILabel!
    
    func configure(plant : PlantHashable) {
        if let image: UIImage = ImageFileManager.shared.getSavedImage(named: plant.plantImageName) {
            plantImageView.image = image
        }
        let week = plant.waterPlan.components(separatedBy: ",")
        week.forEach {
            watherPlanLabels[Int($0)! - 1].layer.cornerRadius = 10
            watherPlanLabels[Int($0)! - 1].layer.backgroundColor = #colorLiteral(red: 0.8941176471, green: 0.7490196078, blue: 0.7019607843, alpha: 1)
        }
        dateLabel.text = plant.registerDate
        plantNameLabel.text = plant.plantName
        
        plantId = plant.id
        imageViewConfigure()
    }
    
    private func imageViewConfigure() {
        plantImageView.layer.cornerRadius = 10
    }
    
    @IBAction func trashTapped(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: "반려 식물 물 주기를 등록하시겠습니까?", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "네", style: .default) { [weak self] _ in
            guard let self = self else { return }
            PlantsRealm.shared.deletePlant(plantid: self.plantId!) {
                if $0 { self.delegate?.reloadCollection() }
            }
        }
        alert.addAction(yesAction)
        let noAction = UIAlertAction(title: "아니오", style: .cancel) { _ in }
        alert.addAction(noAction)
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true)
        
    }
}
