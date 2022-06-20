//
//  RegisterDiaryViewController.swift
//  GrowingPlants
//
//  Created by haeseongJung on 2022/06/19.
//

import UIKit

class RegisterDiaryViewController: UIViewController {
    var keyHeight: CGFloat?
    
    @IBOutlet weak var diaryTitleTextField: UITextField!
    @IBOutlet weak var diaryDate: UILabel!
    @IBOutlet weak var todayPlantImage: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var diaryTextField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        diaryTextField.delegate = self
    }
    
    @objc func keyboardUp(notification:NSNotification) {
        if let keyboardFrame:NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            UIView.animate(withDuration: 0.3 , animations: { self.view.transform = CGAffineTransform(translationX: 0, y: -keyboardRectangle.height) } )
        }
    }
    
    @objc func keyboardDown() {
        self.view.transform = .identity
    }
    
    // 등록 버튼 누름
    @IBAction func diaryRegisterTapped(_ sender: Any) {
        
    }
    
    // 키보드 닫음
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    private func setTextViewPlaceholder() {
        if diaryTextField.text == "" {
            diaryTextField.text = "메모"
            diaryTextField.textColor = UIColor.lightGray
        } else if diaryTextField.text == "메모"{
            diaryTextField.text = ""
            diaryTextField.textColor = UIColor.black
        }
    }
}

extension RegisterDiaryViewController: UITextViewDelegate {
    
    //textView 편집 시작
    func textViewDidBeginEditing(_ textView: UITextView) {
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        setTextViewPlaceholder()
    }
    
    //textView 편집 끝
    
    func textViewDidEndEditing(_ textView: UITextView) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown), name: UIResponder.keyboardWillHideNotification, object: nil)
        if textView.text == "" {
            setTextViewPlaceholder()
        }
    }
    
    //textView 특정 text 가 대체될 때 호출
    //개행문자 시 textView 의 활성화를 포기하는 요청을 보내서 키보드를 내림
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
}
