//
//  MyPlantDiaryCollectionViewCell.swift
//  GrowingPlants
//
//  Created by haeseongJung on 2022/06/23.
//

import UIKit

class MyPlantDiaryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var diaryImageView: UIImageView!
    @IBOutlet weak var diaryTextField: UITextField!
    
    func configure(diary: DiaryHashable) {
        self.imageConfigure()
        if let image: UIImage = ImageFileManager.shared.getSavedImage(named: diary.diaryImageName) {
            diaryImageView.image = image
        }
        dateLabel.text = diary.registerDate
        diaryTextField.text = diary.diaryContents
    }
    
    private func imageConfigure() {
        diaryImageView.layer.cornerRadius = 10
    }
}
