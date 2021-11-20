//
//  LoadingImageView.swift
//  MoveoTest
//
//  Created by Ruben Mimoun on 12/11/2021.
//

import Foundation
import UIKit
import FirebaseWrapperSPM

class LoadingImageView : UIView{
    
    @IBOutlet weak var contentView : UIView!
    @IBOutlet weak var imageHolder: UIImageView!
    lazy var activityLoader : UIActivityIndicatorView = {
       return UIActivityIndicatorView()
    }()
    
    private func commonInit(){
        Bundle.main.loadNibNamed("LoadingImageView", owner: self, options: nil)
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        setupShape()
    }
    
    private func setupShape(){
        shadeView()
        setRoundCorners(cornerRadius: self.frame.height / 2)
        layer.masksToBounds = true
        imageHolder.setRoundCorners(cornerRadius: self.frame.height / 2)
    }
    
    private func startLoading(){
        imageHolder?.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        activityLoader.frame = CGRect(origin: CGPoint(x: frame.width/2 - 20, y: self.frame.height / 2  - 20), size: CGSize(width: 40, height: 40))
        addSubview(activityLoader)
        activityLoader.color = .purple
        activityLoader.startAnimating()
    }
    
    private func stopLoading(){
        activityLoader.stopAnimating()
        activityLoader.removeFromSuperview()
        animateToBounds()
    }
    
    private func animateToBounds(){
        UIView.animate(withDuration: 0.7, delay: 0, options: [.beginFromCurrentState]) {[weak self] in
            self?.imageHolder?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    
    func setImage(url : String?){
        startLoading()
        guard let url = url,
              let imageUrl =  URL(string: url) else {
                  stopLoading()
                  return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 ) {[weak self] in
            self?.imageHolder.sd_setImage(with: imageUrl) {[weak self] _, error, _, _ in
                self?.stopLoading()
                if let _ =  error{
                    self?.imageHolder.image =  UIImage(systemName: "questionmark.circle")!
                }
            }
        }
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
