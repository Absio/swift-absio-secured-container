//
//  MainViewController.swift
//  AbsioCRUD
//
//  Created by admin on 4/12/18.
//  Copyright © 2018 Absio. All rights reserved.
//

import Foundation
import UIKit
import AbsioSDKiOS
import PromiseKit

class MainViewController: UITableViewController {
    var containers : [ContainerInfo] = []
    
    @IBOutlet weak var containerAddToolbarItem: UIBarButtonItem!
    
    var containerIdForSegue : UUID?
    
    @IBAction func addContainer(_ sender: Any) {
        self.performSegue(withIdentifier: "edit", sender: self)
    }
    
    func updateContainers(){
        LoadingView.start(vc: self)
        
        try! AbsioSession.getSesssion().getEvents(eventType: EventType.container)
            .done{ events in
            var containers : [ContainerInfo] = []
            
            for event in events{
                let newContainerInfo = ContainerInfo(id: event.containerId!, header: "", date: "", type: "file")
                containers = containers.filter({$0.id != event.containerId})
                
                if (event.action != ActionType.deleted){
                    containers.append(newContainerInfo)
                }
            }
            
            self.containers = containers
            
            LoadingView.stop()
            self.tableView.reloadData()
            }.catch{ err in
            LoadingView.stop()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tableView.register(nil, forCellReuseIdentifier: "defaultCell")
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        containerIdForSegue = nil
        
        updateContainers()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "edit"){
            let vc = (segue.destination as! EditContainerViewController)
            if (containerIdForSegue == nil){
                vc.setAddMode()
            }else{
                vc.loadContainer(containerId: containerIdForSegue!)
            }
        }
    }
    
    @IBAction func settingsAction(_ sender: Any) {
        performSegue(withIdentifier: "settings", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reusable = tableView.dequeueReusableCell(withIdentifier: "containerCell", for: indexPath)
        let cell = reusable as! ContainerInfoCell
        let model = containers[indexPath.row]
        
        cell.containerIdLabel.text = model.id.uuidString.lowercased()
        cell.typeLabel.text = model.type
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        containerIdForSegue = containers[indexPath.row].id
        self.performSegue(withIdentifier: "edit", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return containers.count
    }
}
