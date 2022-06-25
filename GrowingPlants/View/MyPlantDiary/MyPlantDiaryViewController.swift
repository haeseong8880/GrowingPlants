//
//  MyPlantDiaryViewController.swift
//  GrowingPlants
//
//  Created by haeseongJung on 2022/06/19.
//

import UIKit

class MyPlantDiaryViewController: UIViewController {
    
    var planInfo: PlantHashable?
    var diaryList: [DiaryHashable] = []
    var keyboardNotification: Bool = false
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var notiLabel: UILabel!
    
    typealias Item = DiaryHashable
    enum Section {
        case main
    }
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "\(planInfo?.plantName ?? "")의 반려식물 일기"
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        self.cellConfigure()
        self.reloadCollection()
        self.collectionView.collectionViewLayout = layout()
        
        if self.diaryList.count > 0 {
            collectionView.isHidden = false
            notiLabel.isHidden = true
        } else {
            collectionView.isHidden = true
            notiLabel.isHidden = false
        }
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
                self.view.transform = CGAffineTransform(translationX: 0, y: -keyboardRectangle.height + 50)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: Notification){
        self.view.transform = .identity
    }
    
    private func cellConfigure() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyPlantDiaryCollectionViewCell", for: indexPath) as? MyPlantDiaryCollectionViewCell else { return nil }
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor.lightGray.cgColor
            cell.layer.cornerRadius = 10
            
            cell.index = indexPath.item
            cell.plantId = self.planInfo?.id
            cell.delegate = self
            cell.configure(diary: self.diaryList[indexPath.item])
            return cell
        })
    }
    
    private func layout() -> UICollectionViewCompositionalLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(390))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(400))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        section.interGroupSpacing = 10
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    @IBAction func registerDiary(_ sender: Any) {
        let storyboard = UIStoryboard(name: "RegisterDiary", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RegisterDiaryViewController") as! RegisterDiaryViewController
        vc.delegate = self
        vc.reference = planInfo?.id
        present(vc, animated: true)
    }
}

extension MyPlantDiaryViewController: sendDataDelegate {
    func reloadCollection() {
        self.collectionView.isHidden = false
        self.notiLabel.isHidden = true
        guard let reference = planInfo?.id else { return }
        self.diaryList = DiaryRealm.shared.getPlants(reference: reference)
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(self.diaryList, toSection: .main)
        dataSource.apply(snapshot)
    }
}
