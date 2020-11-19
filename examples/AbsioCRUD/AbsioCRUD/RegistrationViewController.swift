//
//  RegistrationViewController.swift
//  AbsioCRUD
//
//  Created by admin on 4/12/18.
//  Copyright © 2018 Absio. All rights reserved.
//

import Foundation
import UIKit

class RegistrationViewController : UIViewController{
    @IBAction func registerAction(_ sender: Any) {
        let password = passwordField.text ?? ""
        let passphrase = passphraseField.text ?? ""
        let reminder = reminderField.text ?? ""
        
        guard password != "" else {
            Alert.showErrorAlert(vc: self, message: "Please enter valid Password")
            return
        }
        
        guard passphrase != "" else {
            Alert.showErrorAlert(vc: self, message: "Please enter valid Passphrase")
            return
        }
        
        LoadingView.start(vc: self)
        
        try! AbsioSession.register(password: password, passphrase: passphrase, reminder: reminder )
            .done{ userID in
                LoadingView.stop()
                let loginVC = self.navigationController!.viewControllers[0] as! LoginViewController
                loginVC.userID = userID
                self.navigationController?.popViewController(animated: true)
        }.catch{ error in
            LoadingView.stop()
            Alert.showErrorAlert(vc: self, message: error.localizedDescription)
        }
    }
    
    @IBOutlet weak var passphraseField: UITextField!
    @IBOutlet weak var reminderField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
}
