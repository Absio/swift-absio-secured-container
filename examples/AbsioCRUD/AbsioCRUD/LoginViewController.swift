//
//  ViewController.swift
//  AbsioCRUD
//
//  Created by admin on 4/2/18.
//  Copyright © 2018 Absio. All rights reserved.
//

import UIKit
import AbsioSDKiOS


class LoginViewController: UIViewController {
    @IBOutlet weak var passphraseTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userIdTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    public var userID : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if (userID != nil){
            userIdTextField.text = userID!
            showMainView()
        }else{
            userIdTextField.text = UserDefaults.standard.string(forKey: "id")
        }
    }
    
    @IBAction func registerAction(_ sender: Any) {
        performSegue(withIdentifier: "register", sender: self)
    }
    
    @IBAction func loginAction(_ sender: Any) {
        guard let userId = UUID(uuidString: userIdTextField.text ?? "") else {
            Alert.showErrorAlert(vc: self, message: "Please enter valid user ID")
            userIdTextField.becomeFirstResponder()
            return
        }
        
        LoadingView.start(vc: self)
        
        try! AbsioSession.login(userId: userId, password: passwordTextField.text, passphrase: passphraseTextField.text)
            .done(){ _ in
                LoadingView.stop()
                self.showMainView()
        }.catch{
            error in
            LoadingView.stop()
            Alert.showErrorAlert(vc: self, message: error.localizedDescription)
            
            return
        }
    }
    
    func showMainView(){
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        
        guard let rootViewController = window.rootViewController else {
            return
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainVC")
        vc.view.frame = rootViewController.view.frame
        vc.view.layoutIfNeeded()
        
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.rootViewController = vc
        }, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

