//
//  NoteListViewModel.swift
//  MoveoTest
//
//  Created by Ruben Mimoun on 12/11/2021.
//

import Foundation
import UIKit
import MapKit


class NoteListViewModel {
    
    var observer : Observable<[Note]> = Observable(value: [])
    var notesViewModel = [NoteCellViewModel]()
    
    func bind(tableView : UITableView){
        observer.bind {[weak self] notes in
            guard var notes = notes else {return}
            notes.sort(by: {$0.timestamp > $1.timestamp})
            notes.forEach{
                self?.notesViewModel.append(NoteCellViewModel(observer: Observable(value: $0)))
            }
            DispatchQueue.main.async {
                tableView.reloadData()
            }
        }
    }
    
    func bind(mapView : MKMapView){
        observer.bind { notes in
            var mAnnotations = [NotesMapAnnotation]()
            if let note = notes, note.count > 0{
                let filtered = note.filter{ return $0.coordinate != nil}
                filtered.forEach{
                    mAnnotations.append(NotesMapAnnotation(title: $0.title, coordinate: $0.coordinate!, info: $0.content, viewModel: NoteCellViewModel(observer: Observable(value: $0))))
                }
                DispatchQueue.main.async {
                    mapView.mapType = .standard
                    mapView.showAnnotations(mAnnotations, animated: true)
                }
            }
            
        }
    }
    
}
