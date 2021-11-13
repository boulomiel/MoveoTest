//
//  LoginHandler.swift
//  MoveoTest
//
//  Created by Ruben Mimoun on 12/11/2021.
//

import Foundation
protocol LoginHandlerDelegate : AnyObject {
    func onLoginSuccess(user  : MoveoUser?)
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
                self?.handleSuccess(email: user.email)
            case .failure(let error):
                self?.controller.onLoginError(error: error)
            }
        }
    }
    
    private func handleSuccess(email : String?){
        guard let email = email else {
            return
        }
        FirebaseDataManager.shared.retrieveCurrentUser(type: MoveoUser.self,collectionName: Collections.users, email: email) { users in
            DispatchQueue.main.async {[weak self] in
                if users.isEmpty {
                    self?.controller.onLoginError(error: AuthError.noResult)
                }
                if let user =  users.first {
                    self?.controller.onLoginSuccess(user: user)
                }
            }
        }
    }
}
