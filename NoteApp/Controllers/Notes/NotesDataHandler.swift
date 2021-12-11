//
//  NotesDataHandler.swift
//  MoveoTest
//
//  Created by Ruben Mimoun on 14/11/2021.
//

import Foundation

protocol NotesDataDelegate : AnyObject{
    func dataFetched(notes : [Note])
    func noDataFetched()
}

class NotesDataHandler {
        
    weak var controller : NotesDataDelegate?
    
    init(delegate : NotesDataDelegate){
        self.controller = delegate
    }
    
    func fetchData(){
        FirebaseDataManager.shared.retrieve(type: Note.self, collectioName: "\(Collections.notes)\(FirebaseAuthManager.shared.currentUser!.email)") {[weak self] notes in
            guard let notes =  notes, notes.count > 0 else {
                DispatchQueue.main.async {
                    self?.controller?.noDataFetched()
                }
                return
            }
            DispatchQueue.main.async {
                self?.controller?.dataFetched(notes: notes)
            }
        }
    }
    
}
