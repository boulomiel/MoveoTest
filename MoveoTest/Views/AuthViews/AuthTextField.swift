//
//  AuthTextField.swift
//  MoveoTest
//
//  Created by Ruben Mimoun on 11/11/2021.
//

import Foundation
import UIKit

class AuthTextField : UITextField{
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure(){
        shadeView()
    }
}
