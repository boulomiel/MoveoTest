//
//  NoNoteView.swift
//  MoveoTest
//
//  Created by Ruben Mimoun on 12/11/2021.
//

import Foundation
import UIKit

class NoNoteView : UIView{
    
    @IBOutlet weak var contentView : UIView!
    
    private func commonInit(){
        Bundle.main.loadNibNamed("NoNoteView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
}
