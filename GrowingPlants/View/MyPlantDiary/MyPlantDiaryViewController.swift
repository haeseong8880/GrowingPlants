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
    @IBOutlet weak var collectionView: UICollectionView!
    
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
    }
    
    private func cellConfigure() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyPlantDiaryCollectionViewCell", for: indexPath) as? MyPlantDiaryCollectionViewCell else { return nil }
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor.lightGray.cgColor
            cell.layer.cornerRadius = 10
            
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
        guard let reference = planInfo?.id else { return }
        self.diaryList = DiaryRealm.shared.getPlants(reference: reference)
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(self.diaryList, toSection: .main)
        dataSource.apply(snapshot)
    }
}
