//
//  MyPlantDiaryCollectionViewCell.swift
//  GrowingPlants
//
//  Created by haeseongJung on 2022/06/23.
//

import UIKit

class MyPlantDiaryCollectionViewCell: UICollectionViewCell {
    
    var diaryInfo: DiaryHashable?
    var editingButtonCheck: Bool = false
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var diaryImageView: UIImageView!
    @IBOutlet weak var diaryTextField: UITextField!
    @IBOutlet weak var editingButton: UIButton!
    
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
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
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
    
    @IBAction func editingButtonTapped(_ sender: UIButton) {
        print("aaaaaaaa")
        if editingButtonCheck {
            print("bbbbbbb")
            sender.setImage(UIImage(named: "doc.append.fill"), for: .normal)
        } else {
            print("cccccccc")
            sender.setImage(UIImage.init(named: "pencil.tip"), for: .normal)
        }
       
        self.editingButtonCheck = !self.editingButtonCheck
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
