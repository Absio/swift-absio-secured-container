//
//  ChangeCredentialsViewController.swift
//  AbsioCRUD
//
//  Created by admin on 4/13/18.
//  Copyright © 2018 Absio. All rights reserved.
//

import Foundation
import UIKit

class ChangeCredentialsViewController : UIViewController {
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var reminderTextField: UITextField!
    @IBOutlet weak var passphraseTextField: UITextField!
    
    @IBAction func changeCredentialsAction(_ sender: Any) {
        LoadingView.start(vc: self)
        
        try! AbsioSession.getSesssion().changeCredentials(password: passwordTextField.text ?? "", passphrase: passphraseTextField.text ?? "").done{ _ in
            Alert.show(vc: self, title: "Credentials changed succsessfully", message: "")
            self.navigationController!.popViewController(animated: true)
            LoadingView.stop()
        }.catch{
            error in
            LoadingView.stop()
            Alert.showErrorAlert(vc: self, message: error.localizedDescription)
            return
        }
    }
}
