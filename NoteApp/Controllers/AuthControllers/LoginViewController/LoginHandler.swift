//
//  LoginHandler.swift
//  MoveoTest
//
//  Created by Ruben Mimoun on 12/11/2021.
//

import Foundation
protocol LoginHandlerDelegate : AnyObject {
    func onLoginError(error : AuthError)
}

class LoginHandler{
    
    weak var controller : LoginHandlerDelegate!
    
    init(delegate : LoginHandlerDelegate){
        self.controller =  delegate
    }
    
    func proceedLogin(email : String , password : String){
        FirebaseAuthManager.shared.login(email: email, password: password) {[weak self]result in
            switch result{
            case .success(let user):
                print("Login Success", user.debugDescription)
            case .failure(let error):
                self?.controller.onLoginError(error: error)
            }
        }
    }
}
