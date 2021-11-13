//
//  User.swift
//  MoveoTest
//
//  Created by Ruben Mimoun on 12/11/2021.
//

import Foundation
import FirebaseWrapperSPM

struct MoveoUser : FirebaseCodable{
    let id : String
    let name : String
    let familyName : String
    let email : String
    let password : String
}
