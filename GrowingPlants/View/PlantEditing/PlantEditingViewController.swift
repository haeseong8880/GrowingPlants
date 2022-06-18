//
//  PlantEditingViewController.swift
//  GrowingPlants
//
//  Created by haeseongJung on 2022/06/17.
//

import UIKit

class PlantEditingViewController: UIViewController {

    var plantInfo: PlantHashable?
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var plantName: UILabel!
    @IBOutlet weak var plantRegisterDate: UILabel!
    @IBOutlet weak var plantImage: UIImageView!
    @IBOutlet var watherPlanLabels: [UILabel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(plantInfo)
        self.configure()
        self.layerConfigure()
    }
    
    private func configure() {
        guard let plant = plantInfo else { return }
        plantName.text = plant.plantName
        plantRegisterDate.text = plant.registerDate
        if let image: UIImage = ImageFileManager.shared.getSavedImage(named: plant.plantImageName) {
            plantImage.image = image
        }
        let week = plant.waterPlan.components(separatedBy: ",")
        week.forEach {
            watherPlanLabels[Int($0)! - 1].layer.cornerRadius = 10
            watherPlanLabels[Int($0)! - 1].layer.backgroundColor = #colorLiteral(red: 0.8941176471, green: 0.7490196078, blue: 0.7019607843, alpha: 1)
        }
    }
    
    private func layerConfigure() {
        backgroundView.layer.cornerRadius =  10
        backgroundView.layer.borderWidth = 1
        backgroundView.layer.borderColor = UIColor.lightGray.cgColor
        
        plantImage.layer.cornerRadius = 10
    }
}
