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
        shadeView()
        setRoundCorners(cornerRadius: self.frame.height / 2)
        startLoading()
        
    }
    
    private func startLoading(){
        activityLoader.frame = CGRect(origin: CGPoint(x: frame.width/2 - 20, y: self.frame.height / 2  - 20), size: CGSize(width: 40, height: 40))
        addSubview(activityLoader)
        activityLoader.startAnimating()
    }
    
    private func stopLoading(){
        activityLoader.stopAnimating()
        activityLoader.removeFromSuperview()
    }
    
    func setImage(url : String?){
        guard let url = url,
              let imageUrl =  URL(string: url) else {
                  stopLoading()
                  return
              }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 ) {[weak self] in
            self?.imageHolder.sd_setImage(with: imageUrl) {[weak self] _, error, _, _ in
                self?.stopLoading()
                if let _ =  error{
                    self?.imageHolder.image =  UIImage(systemName: "camera.metering.unknown")!
                    return
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
