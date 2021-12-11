//
//  NotesPageViewController.swift
//  tabsandpage
//
//  Created by Ruben Mimoun on 11/11/2021.
//

import Foundation
import UIKit

protocol NotesStoryBoard {}

class NotesTabsViewController : UITabBarController, NotesStoryBoard{
    
    var currentUser : MoveoUser?{
        didSet{
            navigationItem.title = "Hey \(currentUser?.name ?? FallDown.stranger) !"
            FirebaseAuthManager.shared.currentUser = currentUser
        }
    }
    
    lazy var floatingPointOrigin : CGRect = {
      return  CGRect(origin: CGPoint(x: self.view.frame.maxX - 83, y: 80), size: CGSize(width: 80, height: 80))
    }()
    
    lazy var floatingButton : FloatingButton = {
        return FloatingButton(frame: floatingPointOrigin)
    }()
    
    var noteListViewModel : NoteListViewModel? =  NoteListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(floatingButton)
        addNavigationItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        floatingButton.frame = floatingPointOrigin
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    private func addNavigationItems(){
        self.tabBar.backgroundColor = .purple.withAlphaComponent(0.5)
        self.navigationItem.setHidesBackButton(true, animated: false )
        self.navigationItem.leftBarButtonItem =  UIBarButtonItem(image: UIImage(systemName: "person.fill.xmark"), style: .plain, target: self, action: #selector(backToLogin))
    }
        
    @objc func backToLogin(){
        Router.showError(title: Title.logout, messageString: Message.logout) {
            FirebaseAuthManager.shared.logout()
        }
    }
    
    @objc func toAddNewNotes(){
        Router.showNotesEditViewController()
    }
    
    deinit{
        self.currentUser = nil
    }
}
