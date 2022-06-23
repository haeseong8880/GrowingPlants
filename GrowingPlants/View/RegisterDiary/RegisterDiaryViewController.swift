//
//  RegisterDiaryViewController.swift
//  GrowingPlants
//
//  Created by haeseongJung on 2022/06/19.
//

import UIKit

class RegisterDiaryViewController: UIViewController {
    
    var reference: Int?
    var delegate: sendDataDelegate?
    
    @IBOutlet weak var diaryTitleTextField: UITextField!
    @IBOutlet weak var diaryDate: UILabel!
    @IBOutlet weak var todayPlantImage: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var imageBackgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateLabelText()
        
        diaryTitleTextField.attributedPlaceholder = NSAttributedString(
            string: "한줄 일기를 입력해주세요 📝",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 키보드 관련
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillAppear(notification: Notification){
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            UIView.animate(withDuration: 0.33) {
                self.view.transform = CGAffineTransform(translationX: 0, y: -keyboardRectangle.height + 80)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: Notification){
        self.view.transform = .identity
    }
    
    // 등록 버튼 누름
    @IBAction func diaryRegisterTapped(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: "한줄 일기를 등록 하시겠습니까?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "네", style: .default) { [weak self] _ in
            guard let self = self else { return }
            // 시뮬레이터 플랫폼 체크
            if Platform.isSimulator {
                self.todayPlantImage.image = UIImage(named: "plant")
            }
            if self.diaryTitleTextField.text != nil && self.todayPlantImage.image != nil {
                let uniqueFileName: String = Utility.shared.makeImageName()
                ImageFileManager.shared.saveImage(image: self.todayPlantImage.image!, name: uniqueFileName) { result in
                    if result {
                        let diary = DiaryEntity()
                        diary.registerDate = self.diaryDate.text!
                        diary.diaryContents = self.diaryTitleTextField.text!
                        diary.diaryImageName = uniqueFileName
                        diary.referenceNumber = self.reference!
                        DiaryRealm.shared.savePlant(diary: diary) {
                            if $0 {
                                self.delegate?.reloadCollection()
                                self.dismiss(animated: true)
                            }
                        }
                    }
                }
            } else {
                self.present(ShowPopup.shared.alert(title: "알림", message: "반려 식물 사진, 한줄 일기를 입력해주세요."), animated: true, completion: nil)
            }
        }
        alert.addAction(yesAction)
        let noAction = UIAlertAction(title: "아니오", style: .cancel) { _ in }
        alert.addAction(noAction)
        self.present(alert, animated: true)
    }
    
    @IBAction func cameraButtonTapped(_ sender: Any) {
        let camera = UIImagePickerController()
        camera.sourceType = .camera
        camera.allowsEditing = true
        camera.cameraDevice = .rear
        camera.cameraCaptureMode = .photo
        camera.delegate = self
        self.present(camera, animated: true, completion: nil)
    }
    
    private func dateLabelText() {
        diaryDate.text = Date().DateToString()
    }
    
    // 키보드 닫음
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
}

// 카메라 설정
extension RegisterDiaryViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            todayPlantImage.image = image
            print(info)
        }
        todayPlantImage.isHidden = false
        cameraButton.isHidden = true
        imageBackgroundView.backgroundColor = nil
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
