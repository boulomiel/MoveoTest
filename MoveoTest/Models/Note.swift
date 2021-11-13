//
//  Note.swift
//  MoveoTest
//
//  Created by Ruben Mimoun on 12/11/2021.
//

import Foundation
import FirebaseWrapperSPM
import MapKit

struct Note : FirebaseCodable{
    var id : String
    var title : String
    var content : String
    var location : NoteLocation?
    var timestamp : Int
    var imageURL : String?
    
    var uuid  : String{
        return id
    }
    
    var date : String?{
        let epocTime = TimeInterval(timestamp)
        let date = Date(timeIntervalSince1970: epocTime)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "MM/dd/yyyy"
        return dateFormatter.string(from: date)
    }
    
    var coordinate : CLLocationCoordinate2D?{
        if let location = location {
            return CLLocationCoordinate2D(latitude: location.lat, longitude: location.long)
        }
        return CLLocationCoordinate2D()
    }
}
