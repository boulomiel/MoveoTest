//
//  FirebaseManager.swift
//  MoveoTest
//
//  Created by Ruben Mimoun on 10/11/2021.
//

import Foundation
import FirebaseAuth

class FirebaseAuthManager{
    
    static let shared =  FirebaseAuthManager()
    private var authListener: AuthStateDidChangeListenerHandle?
    var currentUser : MoveoUser?
    
    func register(email : String, password : String, completion : @escaping(Result<User, AuthError>)->()){
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let result = result{
                completion(.success(result.user))
            }
            if let error = error{
                completion(.failure(.error(error.localizedDescription)))
            }
        }
    }
    
    func login(email : String, password : String, completion : @escaping(Result<User, AuthError>)->()){
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let result = result{
                completion(.success(result.user))
            }
            if let error = error{
                completion(.failure(.error(error.localizedDescription)))
            }
        }
    }
    
    func isConnected(completion : @escaping(User?)->()){
        authListener = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let _ = user {
                completion(user)
            } else {
                completion(nil)
            }
        }
    }
    
    func removeAuthListener(){
        if let authListener = authListener {
            Auth.auth().removeStateDidChangeListener(authListener)
        }
    }
    
    func logout(){
        do{
            try Auth.auth().signOut()
        }catch{
            print("logout", error.localizedDescription)
        }
    }
    
    deinit{
        if let authListener = authListener{
            Auth.auth().removeStateDidChangeListener(authListener)
        }
    }
}
