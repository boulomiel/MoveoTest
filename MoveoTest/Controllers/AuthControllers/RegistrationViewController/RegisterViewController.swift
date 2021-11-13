//
//  RegisterViewController.swift
//  tabsandpage
//
//  Created by Ruben Mimoun on 11/11/2021.
//

import Foundation
import UIKit


class RegisterViewController : AuthFieldViewController, AuthPageStoryboard{
    
    @IBOutlet weak var nameTextField: AuthTextField!
    @IBOutlet weak var familyTextField: AuthTextField!
    @IBOutlet weak var emailTextField: AuthTextField!
    @IBOutlet weak var passwordTextField: AuthTextField!
    @IBOutlet weak var registerIndicator: UIActivityIndicatorView!{
        didSet{
            sleepIndicator()
        }
    }
    lazy var registrationHandler  = RegistrationHandler(delegate: self)
    
    override func viewDidLoad(){
        super.viewDidLoad()
        setTextFieldsArr(fields: [nameTextField,familyTextField,emailTextField, passwordTextField])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sleepIndicator()
    }

    @IBAction func registerAction(_ sender: Any){
        guard let name =  nameTextField.text , name.count > 0,
            let family =  familyTextField.text , family.count > 0,
            let email =  emailTextField.text , email.count > 0,
            let pass =  passwordTextField.text , pass.count > 0 else{
                Router.showError(title: Title.register, messageString: Message.register)
            return
        }
        wakeIndicator()
        registrationHandler.proceedRegistration(name: name, family: family, email: email, pass: pass)
    }

    private func wakeIndicator(){
        registerIndicator.isHidden =  false
        registerIndicator.startAnimating()
        registerIndicator.style = .large
        registerIndicator.color = .purple
    }
    
    private func sleepIndicator(){
        registerIndicator.isHidden =  true
        registerIndicator.stopAnimating()
    }
}

extension RegisterViewController : RegistrationDelegate{
    func onRegistrationSuccess(user: MoveoUser?) {
        Router.showNotesTabs(user: user)
    }
    
    func onRegistrationError(error: AuthError) {
        sleepIndicator()
        Router.showError(title: error.title, messageString: error.message){[weak self] in
            self?.cleanField()
        }
    }
}
