//
//  HomeViewController.swift
//  GrowingPlants
//
//  Created by haeseongJung on 2022/06/08.
//

import UIKit
import RealmSwift

class HomeViewController: UIViewController {
    
//    private var plants: [PlantsEntity] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var registerButton: UIButton!
    
    typealias Item = PlantsEntity
    enum Section {
        case main
    }
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("PATH => \(Realm.Configuration.defaultConfiguration.fileURL!)")
        let plantList = PlantsRealm.shared.getPlants()
        
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as? HomeCollectionViewCell else { return nil }
            
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor.lightGray.cgColor
            cell.layer.cornerRadius = 10
            cell.configure(plant: plantList[indexPath.row])
            
            return cell
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(plantList, toSection: .main)
        dataSource.apply(snapshot)
        
        collectionView.collectionViewLayout = layout()
        //        self.updateItemList(with: items)
        //        self.changeButtonTitle()
        
        //        collectionView.dataSource = self
        //        collectionView.delegate = self
        //
        //        if let flowlayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
        //            flowlayout.estimatedItemSize = .zero
        //        }
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
        present(vc, animated: true)
    }
    
    func updateItemList(with list: [PlantsEntity]) {
        let plantList = PlantsRealm.shared.getPlants()
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(plantList, toSection: .main)
        dataSource?.apply(snapshot)
    }
}
