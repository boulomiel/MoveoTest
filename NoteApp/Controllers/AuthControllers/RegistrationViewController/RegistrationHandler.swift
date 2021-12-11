//
//  RegistrationHandler.swift
//  MoveoTest
//
//  Created by Ruben Mimoun on 12/11/2021.
//

import Foundation

protocol RegistrationDelegate : AnyObject {
    func onRegistrationError(error : AuthError)
}

class RegistrationHandler {
    
    weak var controller : RegistrationDelegate!
    
    init(delegate : RegistrationDelegate){
        self.controller =  delegate
    }
    
    func proceedRegistration(name : String, family : String , email : String , pass : String){
        FirebaseAuthManager.shared.register(email: email, password: pass) { result in
            DispatchQueue.main.async {[weak self] in
                switch result {
                case .success(let user):
                    FirebaseDataManager.shared.insert(collectionName: Collections.users, value: MoveoUser(id: user.uid, name: name, familyName: family, email: email, password: pass))
                case .failure(let error):
                    self?.controller.onRegistrationError(error: error)
                }
            }
        }
    }
}
