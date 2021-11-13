//
//  SplashViewController.swift
//  MoveoTest
//
//  Created by Ruben Mimoun on 11/11/2021.
//

import Foundation
import UIKit

class SplashViewController : UIViewController{
    
    lazy var splasConnectionHandler = SplashControllerHandler(delegate: self)
    @IBOutlet weak var loadeView: UIActivityIndicatorView!{
        didSet{
            loadeView.style = .large
            loadeView.color = .purple
            loadeView.startAnimating()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3){[weak self] in
            self?.splasConnectionHandler.checkIfUserIsConnected()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        FirebaseAuthManager.shared.removeAuthListener()
    }
}

extension SplashViewController : SplashHandlerDelegate{
    func isConnected(user: MoveoUser?) {
        Router.showNotesTabs(user: user)
    }
    
    func isNotConnected() {
        Router.showAuthViewController()
    }    
}
