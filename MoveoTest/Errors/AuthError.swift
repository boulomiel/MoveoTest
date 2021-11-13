//
//  AuthError.swift
//  MoveoTest
//
//  Created by Ruben Mimoun on 10/11/2021.
//

import Foundation

enum AuthError : LocalizedError{
    case noResult, error(String)
    
    var title : String {
        return "Oups"
    }
    
    var message : String{
        switch self {
        case .noResult:
            return "No user created"
        case .error(let errorMessage):
            return errorMessage
        }
    }
}
