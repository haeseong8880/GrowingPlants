//
//  HomeCollectionViewCell.swift
//  GrowingPlants
//
//  Created by haeseongJung on 2022/06/15.
//

import UIKit

protocol parentsPageRefresh {
    func pageRefresh()
}

class HomeCollectionViewCell: UICollectionViewCell {
    
    var plantId: Int?
    var plantInfo: PlantHashable?
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
        watherPlanLabels.forEach {
            $0.layer.backgroundColor = #colorLiteral(red: 0.7764705882, green: 0.8235294118, blue: 0.7450980392, alpha: 1)
            $0.layer.cornerRadius = 10
        }
        print(week)
        week.forEach {
            watherPlanLabels[Int($0)!].layer.cornerRadius = 10
            watherPlanLabels[Int($0)!].layer.backgroundColor = #colorLiteral(red: 0.8941176471, green: 0.7490196078, blue: 0.7019607843, alpha: 1)
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
        let alert = UIAlertController(title: nil, message: "반려식물을 삭제하시겠습니까?", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "네", style: .default) { [weak self] _ in
            guard let self = self else { return }
            PlantsRealm.shared.deletePlant(plantid: self.plantId!) {
                if $0 {
                    DiaryRealm.shared.parentsDelete(plantId: self.plantId!) { [self] result in
                        if result {
                            var notificationName:[String] = []
                            let week = self.plantInfo!.waterPlan.components(separatedBy: ",")
                            week.forEach {
                                notificationName.append("\(self.plantInfo?.plantImageName)_\($0)")
                            }
                            print("notificationName ====>>> \(notificationName)")
                            UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers:
                             notificationName)
                            self.delegate?.reloadCollection()
                        }
                    }
                }
            }
        }
        alert.addAction(yesAction)
        let noAction = UIAlertAction(title: "아니오", style: .cancel) { _ in }
        alert.addAction(noAction)
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true)
        
    }
    @IBAction func editingButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "PlantEditing", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PlantEditingViewController") as! PlantEditingViewController
        
        vc.delegate = self
        vc.plantInfo = plantInfo
        
        UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true)
    }
}

extension HomeCollectionViewCell: parentsPageRefresh {
    func pageRefresh() {
        self.delegate?.reloadCollection()
    }
}
