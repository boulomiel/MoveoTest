//
//  SplashConnetionHandler.swift
//  MoveoTest
//
//  Created by Ruben Mimoun on 12/11/2021.
//

import Foundation

protocol SplashHandlerDelegate : AnyObject{
    func isConnected(user : MoveoUser?)
    func isNotConnected()
}

class SplashControllerHandler{
    
    weak var controller : SplashHandlerDelegate?
    
    init(delegate : SplashHandlerDelegate){
        self.controller =  delegate
    }
    
    func checkIfUserIsConnected(){
        FirebaseAuthManager.shared.isConnected{user in
            DispatchQueue.main.async {[weak self] in
                if let user = user{
                    self?.handleUserConnected(email: user.email)
                }else{
                    self?.controller?.isNotConnected()
                }
            }
        }
    }
    
    private func handleUserConnected(email : String?){
        guard let email = email else {
            return
        }
        FirebaseDataManager.shared.retrieveCurrentUser(type: MoveoUser.self,collectionName: Collections.users, email: email) { users in
            DispatchQueue.main.async {[weak self] in
                if users.isEmpty {
                    self?.controller?.isNotConnected()
                }
                if let user =  users.first {
                    self?.controller?.isConnected(user: user)
                }
            }
        }
    }
}
