//
//  NotesEditHandler.swift
//  MoveoTest
//
//  Created by Ruben Mimoun on 13/11/2021.
//

import Foundation
import MapKit

protocol NoteHandlerDelegate : AnyObject{
    func removedNote()
    func addUploadObserver(result : Float)
    func imageUploaded(timestamp : TimeInterval, url : URL?)
    func showError(title: String, message : String)
    func onSuccess()
}

class NoteEditHandler {
    
    weak var controller : NoteHandlerDelegate?
    
    init(delegate : NoteHandlerDelegate){
        self.controller = delegate
    }
    
    func uploadWithImage(image : UIImage){
        let timeStamp = Date().timeIntervalSince1970
        guard let data =  image.pngData(),
              let currentUser = FirebaseAuthManager.shared.currentUser else {
                  return
              }
        FirebaseDataManager.shared.storeImage(data: data, path: "\(currentUser.email)/\(Int(timeStamp))") {[weak self] url in
            self?.controller?.imageUploaded(timestamp: timeStamp, url: url)
        }
        FirebaseDataManager.shared.storageWrapper.addUploadProgressObserver{ [weak self] result in
            DispatchQueue.main.async {[weak self] in
                self?.controller?.addUploadObserver(result: Float(result))
            }
        }
    }
    
    func uploadNote(note: Note, collectionName : String){
        FirebaseDataManager.shared.insert(collectionName: collectionName, value: note, id: note.id){error in
            DispatchQueue.main.async {[weak self] in
                if let error = error {
                    self?.controller?.showError(title: Title.uploadingError, message: error.errorDescription ?? FallDown.somethingWrong)
                }else{
                    self?.controller?.onSuccess()
                }
            }
        }
    }
    
    func updateNote(note: Note, collectionName: String){
        FirebaseDataManager.shared.update(id: note.id, collectionName: collectionName, value: note){error in
            DispatchQueue.main.async {[weak self] in
                if let error = error {
                    self?.controller?.showError(title: Title.errorupdatingData, message: error.errorDescription ?? FallDown.somethingWrong)
                }else{
                    self?.controller?.onSuccess()
                }
            }
        }
    }
    
    func removeNote(id : String?, collectionName : String){
        if let id = id {
            FirebaseDataManager.shared.deleteDocument(id: id, collectionName: collectionName) {[weak self] in
                self?.controller?.removedNote()
            }
        }else{
            controller?.showError(title: Title.oups, message: Message.couldnotremove)
        }
    }
}
