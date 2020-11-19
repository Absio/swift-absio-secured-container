//
//  AccessLevelEditViewController.swift
//  AbsioCRUD
//
//  Created by admin on 4/19/18.
//  Copyright © 2018 Absio. All rights reserved.
//

import Foundation
import AbsioSDKiOS
import UIKit

class AccessLevelEditViewController: UITableViewController {
    var initialAppear : Bool = true
    var initialUserId : UUID?
    var initialPermissions : Permissions?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (initialAppear && initialPermissions != nil){
            userIdTextField.isEnabled = initialUserId == nil || (initialUserId! != AbsioSession.getUserId())
            userIdTextField.text = initialUserId?.uuidString ?? ""
            setPermissions(permissions: initialPermissions!)
        }
        
        initialAppear = false
    }
    
    func setUserId(userId : UUID?, permissions : Permissions){
        initialUserId = userId
        initialPermissions = permissions
    }
    
    @IBAction func update(_ sender: Any) {
        guard let userId = UUID(uuidString : userIdTextField.text ?? "") else {
            Alert.showErrorAlert(vc: self, message: "Please enter valid User Id")
            return
        }
        
        self.navigationController!.popViewController(animated: true)
        let vc = self.navigationController!.topViewController as! AccessLevelListViewController
        vc.updateLevel(newAccessLevel: AccessLevel(userId: userId, permissions: getPermission()))
    }
    
    @IBOutlet weak var userIdTextField: UITextField!
    @IBOutlet weak var downloadPermissionSwitch: UISwitch!
    @IBOutlet weak var decryptSwitch: UISwitch!
    @IBOutlet weak var uploadPermissionSwitch: UISwitch!
    @IBOutlet weak var viewAccessPermissionSwitch: UISwitch!
    @IBOutlet weak var modifyAccessSwitch: UISwitch!
    @IBOutlet weak var modifyTypeSwitch: UISwitch!
    @IBOutlet weak var viewTypeSwitch: UISwitch!
    
    func setPermissions(permissions : Permissions){
        downloadPermissionSwitch.isOn = permissions.contains(.downloadContainer)
        decryptSwitch.isOn = permissions.contains(.decryptContainer)
        uploadPermissionSwitch.isOn = permissions.contains(.uploadContainer)
        viewAccessPermissionSwitch.isOn = permissions.contains(.viewAccess)
        modifyAccessSwitch.isOn = permissions.contains(.modifyAccess)
        modifyTypeSwitch.isOn = permissions.contains(.modifyContainerType)
        viewTypeSwitch.isOn = permissions.contains(.viewContainerType)
    }
    
    func getPermission() -> Permissions {
        var permissions : Permissions = []
        if (downloadPermissionSwitch.isOn){
            permissions.insert(.downloadContainer)
        }
        if (decryptSwitch.isOn){
            permissions.insert(.decryptContainer)
        }
        if (uploadPermissionSwitch.isOn){
            permissions.insert(.uploadContainer)
        }
        if (viewAccessPermissionSwitch.isOn){
            permissions.insert(.viewAccess)
        }
        if (modifyAccessSwitch.isOn){
            permissions.insert(.modifyAccess)
        }
        if (modifyTypeSwitch.isOn){
            permissions.insert(.modifyContainerType)
        }
        if (viewTypeSwitch.isOn){
            permissions.insert(.viewContainerType)
        }
        
        return permissions
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row == 8){
            deleteAccessLevel()
        }
    }
    
    func deleteAccessLevel(){
        let vc = self.navigationController!.topViewController as! AccessLevelListViewController
        if (initialUserId != nil){
            if (initialUserId == AbsioSession.getUserId()){
                Alert.showErrorAlert(vc: self, message: "User Access Level cannot be deleted")
                return
            }
            vc.deleteLevel(userId: initialUserId!)
        }
        
        self.navigationController!.popViewController(animated: true)
    }
}
