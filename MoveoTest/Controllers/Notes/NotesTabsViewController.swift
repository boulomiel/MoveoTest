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
            self.title = "Hey \(currentUser?.name ?? FallDown.stranger)"
            FirebaseAuthManager.shared.currentUser = currentUser
        }
    }
    
    var noteListViewModel : NoteListViewModel? =  NoteListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigationItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func addNavigationItems(){
        self.tabBar.backgroundColor = .purple.withAlphaComponent(0.5)
        self.navigationItem.setHidesBackButton(true, animated: false )
        self.navigationItem.leftBarButtonItem =  UIBarButtonItem(image: UIImage(systemName: "person.fill.xmark"), style: .plain, target: self, action: #selector(backToLogin))
        self.navigationItem.rightBarButtonItem =  UIBarButtonItem(image: UIImage(systemName: "plus.app.fill"),style: .plain, target: self, action: #selector(toAddNewNotes))
    }
        
    @objc func backToLogin(){
        FirebaseAuthManager.shared.logout()
        Router.showError(title: Title.logout, messageString: Message.logout) {
            Router.showAuthViewController()
        }
    }
    
    @objc func toAddNewNotes(){
        Router.showNotesEditViewController()
    }
}
