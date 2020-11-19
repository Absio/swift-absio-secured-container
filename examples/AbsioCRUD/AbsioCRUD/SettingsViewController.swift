//
//  SettingsViewController.swift
//  AbsioCRUD
//
//  Created by admin on 4/13/18.
//  Copyright © 2018 Absio. All rights reserved.
//

import Foundation
import UIKit
import PromiseKit
import UIKit

class SettingsViewController : UITableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 0 && indexPath.row == 0){
            performSegue(withIdentifier: "change", sender: self)
        }
        if (indexPath.section == 0 && indexPath.row == 1){
            Alert.showConfirm(vc: self, title: "Delete User", message: "Are you sure, you want to delete current user?", confirmSelector: deleteUser)
        }
        
        if (indexPath.section == 1 && indexPath.row == 1){
            logout()
        }
        
        if (indexPath.section == 1 && indexPath.row == 0){
            let userID = AbsioSession.getUserId().uuidString
            UIPasteboard.general.string = userID
            Alert.show(vc: self, title: "Copied to clipboard", message: userID)
        }
    }
    
    func deleteUser() {
        LoadingView.start(vc: self)
        try! AbsioSession.getSesssion().deleteUser()
            .done{ _ in
                LoadingView.stop()
                self.logout(clearId: true)
        }.catch{ error in
            LoadingView.stop()
            Alert.showErrorAlert(vc: self, message: error.localizedDescription)
        }
    }
    
    func logout(clearId: Bool = false){
        AbsioSession.logout()
        
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        
        guard let rootViewController = window.rootViewController else {
            return
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginVC")
        vc.view.frame = rootViewController.view.frame
        vc.view.layoutIfNeeded()
        
        if clearId {
          UserDefaults.standard.removeObject(forKey: "id")
        }
        
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.rootViewController = vc
        }, completion: nil)
    }
}
