//
//  HomeViewController.swift
//  GrowingPlants
//
//  Created by haeseongJung on 2022/06/08.
//

import UIKit
import RealmSwift

protocol sendDataDelegate {
    func reloadCollection()
}

class HomeViewController: UIViewController {
    
    var plantList: [PlantHashable] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var plzRegisterPlant: UILabel!
    
    typealias Item = PlantHashable
    enum Section {
        case main
    }
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "나의 반려식물 🪴"
        print("PATH => \(Realm.Configuration.defaultConfiguration.fileURL!)")
        
        self.checkEmpty()
        self.cellConfigure()
        self.reloadCollection()
        self.collectionView.delegate = self
        collectionView.collectionViewLayout = layout()
    }
    
    private func checkEmpty() {
        if self.plantList.isEmpty {
            plzRegisterPlant.isHidden = false
            collectionView.isHidden = true
        } else {
            plzRegisterPlant.isHidden = true
            collectionView.isHidden = false
        }
    }
    
    private func cellConfigure() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as? HomeCollectionViewCell else { return nil }
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor.lightGray.cgColor
            cell.layer.cornerRadius = 10
            
            cell.delegate = self
            cell.plantInfo = self.plantList[indexPath.item]
            cell.configure(plant: self.plantList[indexPath.item])
            
            return cell
        })
    }
    
    private func layout() -> UICollectionViewCompositionalLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(400))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(400))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        section.interGroupSpacing = 10
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func buttonConfigure() {
        registerButton.layer.borderWidth = 1
        registerButton.layer.borderColor = UIColor.black.cgColor
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Register", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        vc.delegate = self
        present(vc, animated: true)
    }
}

extension HomeViewController: sendDataDelegate {
    func reloadCollection() {
        self.plantList = PlantsRealm.shared.getPlants()
        self.checkEmpty()
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(self.plantList, toSection: .main)
        dataSource.apply(snapshot)
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "MyPlantDiary", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MyPlantDiaryViewController") as! MyPlantDiaryViewController
        vc.planInfo = self.plantList[indexPath.item]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
