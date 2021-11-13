//
//  AuthContainerView.swift
//  MoveoTest
//
//  Created by Ruben Mimoun on 12/11/2021.
//

import Foundation
import UIKit
class AuthContainerView : UIView{
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
     func configure(){
        setRoundCorners()
        shadeView(shadowRadius: 8, shadowOpacity: 0.6)
    }
}
