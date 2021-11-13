//
//  AuthButton.swift
//  MoveoTest
//
//  Created by Ruben Mimoun on 12/11/2021.
//

import Foundation
import UIKit

class AuthButton : UIButton{
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
     func configure(){
        shadeView()
        backgroundColor = .systemBlue
        tintColor = .white
        setRoundCorners()
    }
}
