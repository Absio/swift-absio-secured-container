//
//  AccessLevelListViewController.swift
//  AbsioCRUD
//
//  Created by admin on 4/13/18.
//  Copyright © 2018 Absio. All rights reserved.
//

import Foundation
import UIKit
import PromiseKit
import AbsioSDKiOS

class AccessLevelListViewController : UITableViewController {
    var selectedAccessLevel : AccessLevel?
    
    var initialApper : Bool = true
    
    var accessLevels : [AccessLevel] = []
    
    func updateLevel(newAccessLevel : AccessLevel){
        for al in accessLevels  {
            if (al.userId == newAccessLevel.userId){
                accessLevels[accessLevels.firstIndex(of: al)!] = newAccessLevel
                return
            }
        }
        
        accessLevels.append(newAccessLevel)
        tableView.reloadData()
    }
    
    func deleteLevel(userId : UUID){
        for al in accessLevels  {
            if (al.userId == userId){
                accessLevels.remove(at: accessLevels.firstIndex(of: al)!)
                tableView.reloadData()
                return
            }
        }
    }
    
    func setAccessLevels(initialAccessLevels : [AccessLevel]){
        accessLevels = initialAccessLevels
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (initialApper){
            if (accessLevels.count == 0){
                accessLevels.append(AccessLevel(userId: try! AbsioSession.getSesssion().getUserId(), permissions: Permissions.defaultForCreator()))
            }
            tableView.reloadData()
        }
        
        initialApper = false
        
        (self.navigationController?.viewControllers[1] as! EditContainerViewController).setAccessLevels(updatedAccessLevels: accessLevels)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "access") as! AccessCell
        let al = accessLevels[indexPath.row]
        
        cell.userIdLabel.text = al.userId == AbsioSession.getUserId() ? "User Access Level" : al.userId.uuidString
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accessLevels.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedAccessLevel = accessLevels[indexPath.row]
        performSegue(withIdentifier: "accessDetail", sender: self)
    }
    
    @IBAction func addAction(_ sender: Any) {
        selectedAccessLevel = nil
        performSegue(withIdentifier: "accessDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "accessDetail"){
            let vc = (segue.destination as! AccessLevelEditViewController)
            if (selectedAccessLevel == nil){
                vc.setUserId(userId: nil, permissions: Permissions.defaultForReciepient())
            } else {
                vc.setUserId(userId: selectedAccessLevel!.userId, permissions: selectedAccessLevel!.permissions!)
            }
        }
    }
}
