//
//  extension UIView.swift
//  MoveoTest
//
//  Created by Ruben Mimoun on 11/11/2021.
//

import Foundation
import UIKit

extension UIView {
    func shadeView(shadowRadius : CGFloat =  4 , shadowOpacity : Float = 0.3){
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = shadowOpacity
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset =  CGSize(width: 4, height: 2)
    }
    func setRoundCorners(cornerRadius : CGFloat =  15, maskedCorners : CACornerMask = [] ){
        layer.cornerRadius = cornerRadius
        if !maskedCorners.isEmpty{
            layer.maskedCorners = maskedCorners
        }
    }
    
}
