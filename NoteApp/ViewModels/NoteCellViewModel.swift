//
//  NoteCellViewModel.swift
//  MoveoTest
//
//  Created by Ruben Mimoun on 12/11/2021.
//

import Foundation

struct NoteCellViewModel {
    
    var observer : Observable<Note>
    
    func bind(noteCell : NoteCell){
        observer.bind { note in
            DispatchQueue.main.async {
                noteCell.titleLabel.text = note?.title
                noteCell.contentLabel.text = note?.content
                noteCell.dateLabel.text = note?.date
                noteCell.loadingImageView.setImage(url: note?.imageURL)
            }
        }
    }
}
