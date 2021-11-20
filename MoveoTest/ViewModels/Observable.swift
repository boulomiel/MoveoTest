//
//  Observable.swift
//  MoveoTest
//
//  Created by Ruben Mimoun on 11/11/2021.
//

import Foundation

class Observable<T>{
    var value : T?{
        didSet{
            listener?(value)
        }
    }
    private var listener : ((T?)->Void)?
    
    init(value : T?){
        self.value = value
    }
    
    func bind(_ listener : @escaping (T?)->Void){
        listener(value)
        self.listener = listener
    }
}
