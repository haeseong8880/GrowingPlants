//
//  PlantEditingViewController.swift
//  GrowingPlants
//
//  Created by haeseongJung on 2022/06/17.
//

import UIKit

class PlantEditingViewController: UIViewController {

    var plantInfo: PlantHashable?
    var delegate: parentsPageRefresh?
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var plantName: UILabel!
    @IBOutlet weak var plantRegisterDate: UILabel!
    @IBOutlet weak var plantImage: UIImageView!
    @IBOutlet var watherPlanLabels: [UILabel]!
    
    // 수정에 필요한 것들
    @IBOutlet weak var titleStackView: UIStackView!
    @IBOutlet weak var titleEditingStackView: UIStackView!
    @IBOutlet weak var titleEditingTextField: UITextField!
    @IBOutlet weak var plantNameLabel: UILabel!
    
    
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
    
    @IBAction func titleEditingButtonTapped(_ sender: UIButton) {
        if sender.tag == 0 {
            titleEditingStackView.isHidden = false
            titleEditingTextField.placeholder = plantInfo?.plantName
            titleStackView.isHidden = true
        } else {
            if self.titleEditingTextField.text != nil {
                let alert = UIAlertController(title: nil, message: "반려 식물의 이름을 변경 하시겠습니까?", preferredStyle: .alert)
                
                let yesAction = UIAlertAction(title: "네", style: .default) { [weak self] _ in
                    guard let self = self else { return }
                    PlantsRealm.shared.updatePlantName(plantid: self.plantInfo!.id, updateName: self.titleEditingTextField.text!) {
                        if $0 {
                            self.plantNameLabel.text = self.titleEditingTextField.text
                            self.titleEditingStackView.isHidden = true
                            self.titleStackView.isHidden = false
                            self.titleEditingTextField.text = nil
                            self.delegate?.pageRefresh()
                        }
                    }
                }
                alert.addAction(yesAction)
                let noAction = UIAlertAction(title: "아니오", style: .cancel) { _ in }
                alert.addAction(noAction)
                self.present(alert, animated: true)
            } else {
                self.present(ShowPopup.shared.alert(title: "알림", message: "반려 식물의 이름을 입력해주세요."), animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func editingButtonTapped(_ sender: UIButton) {
        print("aaaaaa")
    }
    
    // 키보드 닫음
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
}
