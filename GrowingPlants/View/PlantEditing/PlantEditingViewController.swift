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
    var weekList: [Week] = []
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var plantName: UILabel!
    @IBOutlet weak var plantRegisterDate: UILabel!
    @IBOutlet weak var plantImage: UIImageView!
    @IBOutlet var watherPlanButtons: [UIButton]!
    
    // 수정에 필요한 것들
    @IBOutlet weak var titleStackView: UIStackView!
    @IBOutlet weak var titleEditingStackView: UIStackView!
    @IBOutlet weak var titleEditingTextField: UITextField!
    @IBOutlet weak var plantNameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        watherPlanButtons.forEach { item in
            item.tintColor = #colorLiteral(red: 0.7764705882, green: 0.8235294118, blue: 0.7450980392, alpha: 1)
        }
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
            weekList.append(Week(tagNumber: Int($0)! - 1, weekName: tagNumberChangeWeek(tagNumber: Int($0)! - 1)))
            watherPlanButtons[Int($0)! - 1].layer.cornerRadius = 10
            watherPlanButtons[Int($0)! - 1].tintColor = #colorLiteral(red: 0.8941176471, green: 0.7490196078, blue: 0.7019607843, alpha: 1)
        }
        print(weekList)
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
                            self.titleEditingTextField.placeholder = self.titleEditingTextField.text
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
    
    @IBAction func watherPlanButtonTapped(_ sender: UIButton) {
        watherPlanButtons.forEach { item in
            if item.tag == sender.tag {
                if item.tintColor == #colorLiteral(red: 0.7764705882, green: 0.8235294118, blue: 0.7450980392, alpha: 1) {
                    item.tintColor = #colorLiteral(red: 0.8941176471, green: 0.7490196078, blue: 0.7019607843, alpha: 1)
                    guard let weekName = sender.titleLabel?.text else { return }
                    weekList.append(Week(tagNumber: sender.tag, weekName: weekName))
                } else {
                    for (index, week) in weekList.enumerated() {
                        if week.tagNumber == sender.tag {
                            weekList.remove(at: index)
                        }
                    }
                    item.tintColor = #colorLiteral(red: 0.7764705882, green: 0.8235294118, blue: 0.7450980392, alpha: 1)
                }
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
    
    private func tagNumberChangeWeek(tagNumber: Int) -> String {
        if tagNumber == 0 { return "일"}
        else if tagNumber == 1 { return "월" }
        else if tagNumber == 2 { return "화" }
        else if tagNumber == 3 { return "수" }
        else if tagNumber == 4 { return "목" }
        else if tagNumber == 5 { return "금" }
        else { return "토" }
    }
    
}
