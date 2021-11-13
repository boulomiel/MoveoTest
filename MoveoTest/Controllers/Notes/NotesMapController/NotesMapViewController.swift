//
//  NotesMapViewController.swift
//  tabsandpage
//
//  Created by Ruben Mimoun on 11/11/2021.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class NotesMapViewController : UIViewController, NotesStoryBoard{
    
    @IBOutlet weak var mMap : MKMapView?
    var noteListViewModel : NoteListViewModel?
    var locationManager = CLLocationManager()
    var noteView : NoNoteView?

    override func viewDidLoad() {
        super.viewDidLoad()
        mMap?.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showUserLocation()
        getData()
        setupViewModel()
    }
    
    private func showNoNoteSaved(){
        noteView =  NoNoteView(frame: CGRect(origin: CGPoint(x: 0, y: 85), size: self.view.frame.size))
        self.view.addSubview(noteView!)
        UIView.animate(withDuration: 2.0, delay: 0, options: [.repeat, .autoreverse], animations: {[weak self] in
            if let noteView = self?.noteView {
                noteView.frame = CGRect(origin: CGPoint(x: 0, y: 135), size: noteView.frame.size)
            }
        }, completion: nil)
    }
    
    private func removeNoNotesAnimation(){
        noteView?.layer.removeAllAnimations()
        noteView?.removeFromSuperview()
    }
    
    private func showUserLocation(){
        if let location =  locationManager.location{
            let viewRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
            mMap?.setRegion(viewRegion, animated: false)
            mMap?.showsUserLocation = true
        }
    }
    
    private func setupViewModel(){
        noteListViewModel =  NoteListViewModel()
        if let map = mMap{
            noteListViewModel?.bind(mapView: map)
        }
    }
    
    private func getData(){
        FirebaseDataManager.shared.retrieve(type: Note.self, collectioName: "\(Collections.notes)\(FirebaseAuthManager.shared.currentUser!.email)") {[weak self] notes in
            guard let notes =  notes, notes.count > 0 else {
                DispatchQueue.main.async {
                    self?.showNoNoteSaved()
                }
                return
            }
            self?.noteListViewModel?.observer.value =  notes
            DispatchQueue.main.async {
                self?.removeNoNotesAnimation()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        noteListViewModel?.observer.value = nil
        noteListViewModel = nil
        removeNoNotesAnimation()
        mMap?.removeAnnotations(mMap!.annotations)
    }

}

extension NotesMapViewController : MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation =  annotation as? NotesMapAnnotation else {return nil }
        let reuseId = "pin"

        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
        }else {
            pinView?.annotation = annotation
        }
        let subtitleView = UILabel()
        subtitleView.font = subtitleView.font.withSize(12)
        subtitleView.numberOfLines = 0
        subtitleView.text = annotation.title
        pinView?.detailCalloutAccessoryView = subtitleView
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? NotesMapAnnotation{
            Router.showNotesEditViewController(noteVM: annotation.viewModel)
        }
    }
}

