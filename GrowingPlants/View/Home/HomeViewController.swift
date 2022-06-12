//
//  HomeViewController.swift
//  GrowingPlants
//
//  Created by haeseongJung on 2022/06/08.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var registerButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        
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
}
