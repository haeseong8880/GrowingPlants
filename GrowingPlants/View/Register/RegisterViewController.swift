//
//  RegisterViewController.swift
//  GrowingPlants
//
//  Created by haeseongJung on 2022/06/12.
//

import UIKit

class RegisterViewController: UIViewController {
    
    var delegate: sendDataDelegate?
    private var weekList: [Week] = []
    
    @IBOutlet weak var plantImage: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var imageBackgroundView: UIView!
    @IBOutlet weak var plantNameTextField: UITextField!
    @IBOutlet var weekSelectButtons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageConfigure()
        weekSelectButtons.forEach { item in
            item.tintColor = #colorLiteral(red: 0.7764705882, green: 0.8235294118, blue: 0.7450980392, alpha: 1)
        }
        imageClick()
    }
    
    private func imageClick() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageBackgroundView.isUserInteractionEnabled = true
        imageBackgroundView.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let alert = UIAlertController(title: nil, message: "다시 촬영 하시겠습니까?", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "네", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.cameraEvent()
        }
        alert.addAction(yesAction)
        let noAction = UIAlertAction(title: "아니오", style: .cancel) { _ in }
        alert.addAction(noAction)
        present(alert, animated: true)
    }
    
    private func imageConfigure() {
        plantImage.layer.cornerRadius = 10
        imageBackgroundView.layer.cornerRadius = 10
    }
    
    @IBAction func cameraTapped(_ sender: Any) {
        cameraEvent()
    }
    
    // camera event
    private func cameraEvent() {
        let camera = UIImagePickerController()
        camera.sourceType = .camera
        camera.allowsEditing = true
        camera.cameraDevice = .rear
        camera.cameraCaptureMode = .photo
        camera.delegate = self
        present(camera, animated: true, completion: nil)
    }
    
    // 주기 선택 버튼 클릭!
    @IBAction func weekTapped(_ sender: UIButton) {
        weekSelectButtons.forEach { item in
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
    
    // 등록 버튼 누름
    @IBAction func plantRegisterTapped(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: "반려 식물 물 주기를 등록하시겠습니까?", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "네", style: .default) { [weak self] _ in
            guard let self = self else { return }
            // 시뮬레이터 플랫폼 체크
            if Platform.isSimulator {
                self.plantImage.image = UIImage(named: "plant")
            }
            if !self.plantNameTextField.text!.isEmpty && self.plantImage.image != nil && !self.weekList.isEmpty {
                self.weekList.forEach { item in
                    LocalNotificationUtility.shared.localNotificaitionSetting(week: item, plantName: self.plantNameTextField.text!)
                }
                // UniqueName.jpeg
                let uniqueFileName: String = "\(ProcessInfo.processInfo.globallyUniqueString).jpeg"
                ImageFileManager.shared.saveImage(image: self.plantImage.image!, name: uniqueFileName) { value in
                    if value {
                        var waterPlan = ""
                        for (index, item) in self.weekList.enumerated() {
                            if index == 0 { waterPlan = "\(item.tagNumber)" }
                            else { waterPlan = "\(waterPlan),\(item.tagNumber)" }
                        }
                        print("=====> \(waterPlan)")
                        let plantValue = PlantsEntity()
                        plantValue.plantName = self.plantNameTextField.text!
                        plantValue.waterPlan = waterPlan
                        plantValue.plantImageName = uniqueFileName
                        plantValue.registerDate = Date().DateToString()
                        PlantsRealm.shared.savePlant(plant: plantValue) { value in
                            if value {
                                self.delegate?.reloadCollection()
                                self.dismiss(animated: true)
                            }
                        }
                    }
                }
            } else {
                self.present(ShowPopup.shared.alert(title: "알림", message: "반려 식물 이름, 사진, 물 주기를 입력해주세요."), animated: true, completion: nil)
            }
        }
        alert.addAction(yesAction)
        let noAction = UIAlertAction(title: "아니오", style: .cancel) { _ in }
        alert.addAction(noAction)
        present(alert, animated: true)
    }
    
    // 키보드 닫음
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
}

// 카메라 설정
extension RegisterViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            plantImage.image = image
            print(info)
        }
        plantImage.isHidden = false
        cameraButton.isHidden = true
        imageBackgroundView.backgroundColor = nil
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
