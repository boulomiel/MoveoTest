//
//  Router.swift
//  tabsandpage
//
//  Created by Ruben Mimoun on 11/11/2021.
//

import Foundation
import UIKit

class Router {
    
    private static var root : UIWindow? = {
        guard let firstScene = UIApplication.shared.connectedScenes.first,
              let delegate =  firstScene.delegate as? SceneDelegate,
              let root = delegate.window else {
                  return nil
              }
        return root
    }()
    
    private static var navigationController : UINavigationController? = {
        guard let navController = root?.rootViewController as? UINavigationController else {
                  print("Router", "No navigation controller at the root")
                  return nil}
        return navController
    }()
    
    static func showAuthViewController(){
        let vc : AuthPageviewController = AuthPageviewController.instantiate()
        push(controller: vc)
    }
    
    static func showNotesTabs(user : MoveoUser? = nil){
        let vc : NotesTabsViewController =  NotesTabsViewController.instantiate()
        vc.currentUser = user
        push(controller: vc)
    }
    
    static func showNotesEditViewController(noteVM : NoteCellViewModel? = nil){
        let vc : NotesEditViewController = NotesEditViewController.instantiate()
        vc.viewModel = noteVM
        push(controller: vc)
    }
    
    static func showError(title : String , messageString : String, onClose : (()->Void)? = nil){
        let errorVc : ErrorVC = ErrorVC.instantiate()
        root?.rootViewController?.present(errorVc, animated: true, completion: nil)
        errorVc.titleLabel?.text = title
        errorVc.contentLabel?.text =  messageString
        errorVc.onClose = onClose
    }
    
    static func pop(){
        navigationController?.popViewController(animated: true)
    }
    
    private static func push<T : UIViewController>(controller : T){
        let controllers = navigationController?.viewControllers ?? []
        if !controllers.contains(where: {$0.self is T}){
            navigationController?.pushViewController(controller, animated:  true)
        }else{
            if let index =  controllers.firstIndex(where: {$0 is T}){
                navigationController?.popToViewController(controllers[index], animated: true)
            }
        }
    }
}

extension AuthPageStoryboard{
    static func instantiate<T : UIViewController>() -> T{
        let className = String(describing: self)
        return UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: className) as! T
    }
}

extension NotesStoryBoard {
    static func instantiate<T : UIViewController>() -> T{
        let className = String(describing: self)
        return UIStoryboard(name: "Notes", bundle: nil).instantiateViewController(withIdentifier: className) as! T
    }
}

extension ErrorStoryBoard {
    static func instantiate<T : UIViewController>() -> T{
        let className = String(describing: self)
        return UIStoryboard(name: "Error", bundle: nil).instantiateViewController(withIdentifier: className) as! T
    }
}

