//
//  Tools.swift
//  MoveoTest
//
//  Created by Ruben Mimoun on 13/11/2021.
//

import Foundation
import UIKit


func openSettings(){
    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
        return
    }
    if UIApplication.shared.canOpenURL(settingsUrl) {
        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in })
    }
}
