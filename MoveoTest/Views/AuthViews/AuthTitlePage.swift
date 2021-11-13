//
//  AuthTitlePage.swift
//  MoveoTest
//
//  Created by Ruben Mimoun on 12/11/2021.
//

import Foundation
import UIKit

class AuthPageLabel : UILabel{
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure(){
        backgroundColor = .systemBlue
        setRoundCorners(cornerRadius: 8, maskedCorners: [.layerMaxXMinYCorner, .layerMaxXMaxYCorner])
        clipsToBounds = true
    }
}
