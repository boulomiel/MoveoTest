//
//  ErrorVC.swift
//  MoveoTest
//
//  Created by Ruben Mimoun on 12/11/2021.
//

import Foundation
import UIKit

protocol ErrorStoryBoard{}

class ErrorVC : UIViewController, ErrorStoryBoard{
    
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var contentLabel: UILabel?
    var onClose : (()->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black.withAlphaComponent(0.3)
    }
    
    @IBAction func closeError(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        onClose?()
    }
}
