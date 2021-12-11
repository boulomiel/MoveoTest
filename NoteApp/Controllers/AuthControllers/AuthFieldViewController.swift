//
//  AuthFieldViewController.swift
//  MoveoTest
//
//  Created by Ruben Mimoun on 11/11/2021.
//

import Foundation
import UIKit

class AuthFieldViewController : UIViewController, UITextFieldDelegate{
    
    var textfieldsArr = [UITextField]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNotificationForKeyboard()
    }

    func setTextFieldsArr(fields : [UITextField]){
        self.textfieldsArr = fields
        textfieldsArr.forEach{$0.delegate = self}
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let next = textField.tag + 1
        if next < textfieldsArr.count {
          return textfieldsArr[next].becomeFirstResponder()
        }else{
            textField.layoutIfNeeded()
          return  textField.resignFirstResponder()
        }
    }
    
    func cleanField(){
        textfieldsArr.forEach{
            $0.text = ""
        }
    }
    
    private func setNotificationForKeyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification : Notification){
        if let keyboard = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue{
            let keyboardFrame =  keyboard.cgRectValue
            if textfieldsArr.last!.isEditing{
                self.view.frame.origin.y -= keyboardFrame.height / 3
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification : Notification){
        UIView.animate(withDuration: 0.5) {[weak self] in
            self?.view.frame.origin.y = 0
        }
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
}
