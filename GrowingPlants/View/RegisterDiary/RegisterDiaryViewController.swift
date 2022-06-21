//
//  RegisterDiaryViewController.swift
//  GrowingPlants
//
//  Created by haeseongJung on 2022/06/19.
//

import UIKit

class RegisterDiaryViewController: UIViewController {
    var keyboardHeight: CGFloat?
    
    @IBOutlet weak var diaryTitleTextField: UITextField!
    @IBOutlet weak var diaryDate: UILabel!
    @IBOutlet weak var todayPlantImage: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var diaryTextField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        diaryTextField.text = "오늘의 일기를 입력해주세요"
        diaryTextField.textColor = UIColor.lightGray
        diaryTextField.delegate = self
        
        diaryTitleTextField.attributedPlaceholder = NSAttributedString(
            string: "오늘의 제목을 입력해주세요",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )

        
        // 키보드 관련
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillAppear(notification: Notification){
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            self.keyboardHeight = keyboardRectangle.height
        }
        if let message: String = notification.userInfo?["message"] as? String {
            if message == "1" {
                UIView.animate(withDuration: 0.33) {
                    self.view.transform = CGAffineTransform(translationX: 0, y: -self.keyboardHeight!)
                }
            }
        }
    }
    
    @objc func keyboardWillHide(notification: Notification){
        self.view.transform = .identity
    }

    // 등록 버튼 누름
    @IBAction func diaryRegisterTapped(_ sender: Any) {
        
    }
    
    // 키보드 닫음
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
}

extension RegisterDiaryViewController: UITextViewDelegate {
    
    //textView 편집 시작
    func textViewDidBeginEditing(_ textView: UITextView) {
        NotificationCenter.default.post(
            name: UIResponder.keyboardWillShowNotification,
            object: self,
            userInfo: ["message":"1"]
        )
        setTextViewPlaceholder()
    }
    
    private func setTextViewPlaceholder() {
        if diaryTextField.text == "" {
            diaryTextField.text = "오늘의 일기를 입력해주세요"
            diaryTextField.textColor = UIColor.gray
        } else if diaryTextField.text == "오늘의 일기를 입력해주세요"{
            diaryTextField.text = ""
            diaryTextField.textColor = UIColor.black
        }
    }
    
    //textView 편집 끝
    func textViewDidEndEditing(_ textView: UITextView) {
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
