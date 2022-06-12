//
//  RegisterViewController.swift
//  GrowingPlants
//
//  Created by haeseongJung on 2022/06/12.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var plantImage: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageConfigure()
    }
    
    private func imageConfigure() {
        plantImage.layer.cornerRadius = 10
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
        print("click!!!!")
        // 푸시에 표시 될 컨텐츠
        let content = UNMutableNotificationContent()
        content.title = "반려 식물 물 주기!"
        content.body = "지금은 오후 12시!!!!"
        
        // 푸시 일정 주기
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current

        dateComponents.weekday = sender.tag
        dateComponents.hour = 12
           
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
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
