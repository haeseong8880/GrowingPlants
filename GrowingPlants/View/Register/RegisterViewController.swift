//
//  RegisterViewController.swift
//  GrowingPlants
//
//  Created by haeseongJung on 2022/06/12.
//

import UIKit

class RegisterViewController: UIViewController {
    
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
    }
    
    private func imageConfigure() {
        plantImage.layer.cornerRadius = 10
        imageBackgroundView.layer.cornerRadius = 10
    }
    
    @IBAction func cameraTapped(_ sender: Any) {
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
                    item.tintColor = .red
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
        print("weekList check ====>    \(weekList)")
    }
    
    // Local Notificaion Setting
    private func localNotificaitionSetting(_ week: Week) {
        // 푸시에 표시 될 컨텐츠
        let content = UNMutableNotificationContent()
        content.title = "반려 식물에게 물을 주는 날입니다!"
        content.body = "오늘은 \(week.weekName)요일 입니다."
        
        // 푸시 일정 주기
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        
        dateComponents.weekday = week.tagNumber
        dateComponents.hour = 12
        //        dateComponents.minute = 49
        
        // 트리거 생성
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents, repeats: true)
        
        // Create the request
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString,
                                            content: content, trigger: trigger)
        // Schedule the request with the system.
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
            if error != nil {
                // Handle any errors.
            }
        }
    }
    
    // 등록 버튼 누름
    @IBAction func plantRegisterTapped(_ sender: Any) {
        weekList.forEach { item in
            localNotificaitionSetting(item)
        }
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
