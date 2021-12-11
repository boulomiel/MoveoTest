//
//  File.swift
//  MoveoTest
//
//  Created by Ruben Mimoun on 12/11/2021.
//

import Foundation
import UIKit

extension UITableView{
    func register<T:UITableViewCell>(_ cell : T.Type){
        register(UINib(nibName: String(describing: T.self), bundle: Bundle.main), forCellReuseIdentifier: String(describing: T.self))
    }
    
    func dequeueCell<T : UITableViewCell>(indexPath : IndexPath) -> T{
        let idenfifier =  String(describing: T.self)
        let cell =  dequeueReusableCell(withIdentifier: idenfifier, for: indexPath)
        return cell as! T
    }
}
