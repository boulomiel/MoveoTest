//
//  FirebaseDataManager.swift
//  MoveoTest
//
//  Created by Ruben Mimoun on 10/11/2021.
//

import Foundation
import Firebase
import FirebaseWrapperSPM

struct FirebaseDataManager {

    static let shared = FirebaseDataManager()
    private let firebaseFirestoreWrapper = FiretoreWrapper()
    let storageWrapper = StorageWrapper()
    static func configure(){
        FirebaseWrapper.configure()
    }
    
    func insert<T : FirebaseCodable>(collectionName : String, value : T, id : String, completion : @escaping( (FireWrapperError?) -> Void)){
        firebaseFirestoreWrapper.addDocumentWitId(collectionName: collectionName, data: value, documentId: id)
        completion(nil)
    }
    
    func insert<T : FirebaseCodable>(collectionName : String, value : T){
        firebaseFirestoreWrapper.addData(collectionName: collectionName, data: value) { result in
            switch result{
            case .success(let success):
                print(collectionName, "inserted successfully : \(success)")
            case .failure(let error):
                print(collectionName, "inserted failed : \(error)")
            }
        }
    }
    
    func update<T : FirebaseCodable>(id : String,collectionName : String, value : T, completion : @escaping( (FireWrapperError?) -> Void)){
        firebaseFirestoreWrapper.updateData(for: id, in: collectionName, data: value.toDict()) { result in
            switch result{
            case .success(_):
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    func retrieveCurrentUser<T : FirebaseCodable>(type : T.Type, collectionName : String, email : String, completion : @escaping([T?])->Void){
        let query = firebaseFirestoreWrapper.getQueryEqualTo(in: collectionName, for: "email", value: email)
        firebaseFirestoreWrapper.retrieveMultipleOnce(from: query, decode: T.self) { result in
            switch result{
            case .success(let user):
                let users =  user.compactMap {$0.self}
                completion(users)
            case .failure(_):
                completion([])
            }
        }
    }
    
    func retrieve<T : FirebaseCodable>(type : T.Type, collectioName : String, completion : @escaping([T]?)->Void){
        firebaseFirestoreWrapper.retrieveAllOnce(from: collectioName, decode: type) { result in
            switch result{
            case .success(let data):
                let unNilData =  data.compactMap({$0.self})
                completion(unNilData)
            case .failure(_):
                completion(nil)
            }
        }
    }
    
    func deleteDocument(id : String, collectionName: String, completion: @escaping(()->Void)){
        firebaseFirestoreWrapper.deleteDocuments(at: collectionName, for: id)
        completion()
    }

    func storeImage(data : Data, path : String, completion : @escaping ((URL?) -> Void)){
        guard let ref =  storageWrapper.getReference(for: "/\(path)".trimmingCharacters(in: .whitespacesAndNewlines), from: false) else{
            return
        }
        storageWrapper.uploadFile(from: data, in: ref) { result in
            switch result {
            case .success(let url):
                completion(url)
            case .failure(_):
                completion(nil)
            }
        }
    }
    
    
    
}
