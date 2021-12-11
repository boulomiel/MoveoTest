//
//  NotesMapAnnotation.swift
//  MoveoTest
//
//  Created by Ruben Mimoun on 13/11/2021.
//

import MapKit
import UIKit

class NotesMapAnnotation: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    var viewModel : NoteCellViewModel?

    init(title: String, coordinate: CLLocationCoordinate2D, info: String, viewModel : NoteCellViewModel) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
        self.viewModel = viewModel
    }
}
