//
//  MyPlantDiaryCollectionViewCell.swift
//  GrowingPlants
//
//  Created by haeseongJung on 2022/06/23.
//

import UIKit

class MyPlantDiaryCollectionViewCell: UICollectionViewCell {
    
    var diaryInfo: DiaryHashable?
    var plantId: Int?
    var editingButtonCheck: Bool = false
    var index: Int?
    var delegate: sendDataDelegate?
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var diaryImageView: UIImageView!
    @IBOutlet weak var diaryTextField: UITextField!
    @IBOutlet weak var editingButton: UIButton!
    @IBOutlet weak var editingDoneButton: UIButton!
    
    func configure(diary: DiaryHashable) {
        self.imageConfigure()
        if let image: UIImage = ImageFileManager.shared.getSavedImage(named: diary.diaryImageName) {
            diaryImageView.image = image
        }
        dateLabel.text = diary.registerDate
        diaryTextField.text = diary.diaryContents
        diaryInfo = diary
        
        // imageview click event
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        diaryImageView.isUserInteractionEnabled = true
        diaryImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func imageConfigure() {
        diaryImageView.layer.cornerRadius = 10
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        // Your action
        let alert = UIAlertController(title: nil, message: "다시 재 촬영을 하시겠습니까??", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "네", style: .default) { [weak self] _ in
            let camera = Utility.shared.cameraEvent()
            camera.delegate = self
            UIApplication.shared.keyWindow?.rootViewController?.present(camera, animated: true, completion: nil)
        }
        alert.addAction(yesAction)
        let noAction = UIAlertAction(title: "아니오", style: .cancel) { _ in }
        alert.addAction(noAction)
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true)
    }
    
    // 작업 할 부분
    @IBAction func editingButtonTapped(_ sender: UIButton) {
        if sender.tag == 0 {
            self.diaryTextField.isUserInteractionEnabled = !self.diaryTextField.isUserInteractionEnabled
            self.diaryTextField.becomeFirstResponder()
            //            NotificationCenter.default.post(name: UIResponder.keyboardWillShowNotification, object: nil, userInfo: ["index":index])
            self.editingButton.isHidden = true
            self.editingDoneButton.isHidden = false
        } else {
            if diaryTextField.text != nil && diaryTextField.text != "" {
                let alert = UIAlertController(title: nil, message: "한줄 일기를 수정 하시겠습니까?", preferredStyle: .alert)
                
                let yesAction = UIAlertAction(title: "네", style: .default) { [weak self] _ in
                    guard let self = self else { return }
                    DiaryRealm.shared.dirayContentUpdate(diaryId: self.diaryInfo!.id, updateContent: self.diaryTextField.text!) {
                        if $0 {
                            self.editingButton.isHidden = false
                            self.editingDoneButton.isHidden = true
                            self.delegate?.reloadCollection()
                            self.diaryTextField.isUserInteractionEnabled = !self.diaryTextField.isUserInteractionEnabled
                        }
                    }
                }
                alert.addAction(yesAction)
                let noAction = UIAlertAction(title: "아니오", style: .cancel) { _ in }
                alert.addAction(noAction)
                UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true)
            } else {
                UIApplication.shared.keyWindow?.rootViewController?.present(ShowPopup.shared.alert(title: "알림", message: "한줄 일기를 입력해주세요."), animated: true)
            }
        }
    }
    @IBAction func trashButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: "한줄 일기를 삭제 하시겠습니까?", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "네", style: .default) { [weak self] _ in
            guard let self = self else { return }
            DiaryRealm.shared.deleteDiary(diaryId: self.diaryInfo!.id, plantId: self.plantId!) {
                if $0 { self.delegate?.reloadCollection() }
            }
        }
        alert.addAction(yesAction)
        let noAction = UIAlertAction(title: "아니오", style: .cancel) { _ in }
        alert.addAction(noAction)
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true)
    }
    
    // 키보드 닫음
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        UIApplication.shared.keyWindow?.rootViewController?.view.endEditing(true)
    }
}


// 카메라 설정
extension MyPlantDiaryCollectionViewCell: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            diaryImageView.image = image
        }
        let imageName: String = Utility.shared.makeImageName()
        ImageFileManager.shared.saveImage(image: diaryImageView.image!, name: imageName) {
            if $0 {
                guard let diaryId = self.diaryInfo?.id else { return }
                DiaryRealm.shared.imageUpdate(diaryId: diaryId, updateImageName: imageName) { result in
                    if result {
                        picker.dismiss(animated: true)
                    }
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
