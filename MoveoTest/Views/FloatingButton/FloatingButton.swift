//
//  FloatingButton.swift
//  MoveoTest
//
//  Created by Ruben Mimoun on 13/11/2021.
//

import Foundation
import UIKit

class FloatingButton : UIView{
    
    @IBOutlet weak var contentView : UIView!
    var lastLocation = CGPoint(x: 0, y: 0)

    private func commonInit(){
        Bundle.main.loadNibNamed("FloatingButton", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        contentView.setRoundCorners(cornerRadius: self.frame.height / 2)
        contentView.shadeView()
        initGestures()
    }
    
    private func initGestures(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(detectTap))
        let panRecognizer = UIPanGestureRecognizer(target:self, action:#selector(detectPan))
        self.gestureRecognizers = [panRecognizer, tapGesture]
    }
    
    @objc func detectPan(_ recognizer:UIPanGestureRecognizer) {
        let translation  = recognizer.translation(in: self.superview)
        self.center = CGPoint(x: lastLocation.x + translation.x, y: lastLocation.y + translation.y)
    }
    
    @objc func detectTap(_ recognizer:UITapGestureRecognizer) {
        Router.showNotesEditViewController()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.superview?.bringSubviewToFront(self)
        lastLocation = self.center
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
