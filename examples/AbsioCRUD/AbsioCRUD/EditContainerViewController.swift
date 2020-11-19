//
//  EditContainerViewController.swift
//  AbsioCRUD
//
//  Created by admin on 4/12/18.
//  Copyright © 2018 Absio. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices
import PromiseKit
import AbsioSDKiOS

class EditContainerViewController : UITableViewController, UIDocumentPickerDelegate, UIDocumentInteractionControllerDelegate {
    
    private var accessLevels : [AccessLevel]? = []
    
    @IBAction func submit(_ sender: Any) {
        LoadingView.start(vc: self)
        
        var updatedAccessLevels : [AccessLevel] = []
        
        if (expirationSwitch.isOn){
            if (accessLevels!.count == 0){
                updatedAccessLevels = [AccessLevel(userId: AbsioSession.getUserId(), permissions: Permissions.defaultForCreator())]
            }
            for al in accessLevels!{
                updatedAccessLevels.append(AccessLevel(userId: al.userId, permissions: al.permissions, expiresAt: expirationPicker.date))
            }
        }
        else{
            updatedAccessLevels = accessLevels!
        }
        
        
        if (addMode){
            if (currentData == nil){
                Alert.showErrorAlert(vc: self, message: "Please select file first")
            }
            
            try! AbsioSession.getSesssion().createContainer(content: currentData, customHeaderObject: headerField.text, accessLevels: updatedAccessLevels, type: "file").done{_ -> Void in
                LoadingView.stop()
                self.navigationController!.popViewController(animated: true)
                Alert.show(vc: self, title: "Container Created Successfully", message: "")
            }.catch{ err in
                LoadingView.stop()
                Alert.showErrorAlert(vc: self, message: err.localizedDescription)
            }
        }else{
            try! AbsioSession.getSesssion().updateContainer(containerId: containerToLoad!, content: currentData, customHeaderObject: headerField.text, accessLevels: updatedAccessLevels, type: "file")
                .done{_ in
                    LoadingView.stop()
                    self.navigationController!.popViewController(animated: true)
                    Alert.show(vc: self, title: "Container Updated Successfully", message: "")
            }.catch{ err in
                LoadingView.stop()
                Alert.showErrorAlert(vc: self, message: err.localizedDescription)
            }
        }
    }
    
    @IBAction func expirationChanged(_ sender: Any) {
        expirationPicker.isEnabled = expirationSwitch.isOn
    }
    
    @IBOutlet weak var headerField: UITextField!
    @IBOutlet weak var typeField: UITextField!
    @IBOutlet weak var expirationSwitch: UISwitch!
    @IBOutlet weak var fileNameLabel: UILabel!
    @IBOutlet weak var expirationPicker: UIDatePicker!
    @IBOutlet weak var submitTabBarItem: UIBarButtonItem!
    
    var initialAppear = true
    var containerToLoad : UUID?
    
    var addMode = false
    var currentContainer : Container?
    var currentData : Data?
    
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        let url = urls[0]
        currentData = try! Data(contentsOf: url)
        let filename = url.lastPathComponent
        headerField.text = filename
        typeField.text = "file"
        updateFileName(name: filename)
    }
    
    func loadContainer(containerId : UUID){
        containerToLoad = containerId
    }
    
    func updateFileName(name : String){
        self.fileNameLabel.text = "File : " + name
    }
    
    func loadContainerPostponed(containerId : UUID){
        LoadingView.start(vc: self)
        
        try! AbsioSession.getSesssion().getContainer(containerId: containerId).done{
            cont  in
            self.currentContainer = cont
            
            let header = try cont.header?.getObject(headerType: String.self) ?? ""
            self.accessLevels = Array(cont.accessLevels!.values)
            self.headerField.text = header
            self.typeField.text = cont.containerMetadata?.type ?? ""
            self.updateFileName(name: header)
            LoadingView.stop()
            self.currentData = cont.content
            let expiresAt = cont.accessLevels![AbsioSession.getUserId()]?.expiresAt
            self.expirationSwitch.isOn = expiresAt != nil
            if (expiresAt != nil){
                self.expirationPicker.date = expiresAt!
            }
        }.catch{ err in
            LoadingView.stop()
            Alert.showErrorAlert(vc: self, message: err.localizedDescription)
            self.navigationController!.popViewController(animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        expirationSwitch.isOn = false
        expirationPicker.isEnabled = false
    }
    
    func showPicker() throws{
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.item"], in: .import)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .formSheet
        self.present(documentPicker, animated: true, completion: nil)
    }
    
    func showPreview(filename: String, data : Data) throws{
        
        let documentsUrl = FileManager.default.urls(for: .documentDirectory,
                                                    in: .userDomainMask).first!
        let fileUrl = documentsUrl.appendingPathComponent(filename)
        try data.write(to: fileUrl)
        
        let documentController = UIDocumentInteractionController(url: fileUrl)
        documentController.delegate = self
        documentController.presentPreview(animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if initialAppear {
            if (containerToLoad != nil){
                loadContainerPostponed(containerId: containerToLoad!)
            }
            
            if (addMode){
                setAddModePosponed()
            }
            
        }
        
        initialAppear = false
    }
    
    func showFile(filename: String, data : Data) throws{
        
        let documentsUrl = FileManager.default.urls(for: .documentDirectory,
                                                    in: .userDomainMask).first!
        let fileUrl = documentsUrl.appendingPathComponent(filename)
        try data.write(to: fileUrl)
        
        let documentController = UIDocumentInteractionController(url: fileUrl)
        documentController.delegate = self
        documentController.presentOptionsMenu(from: self.view.bounds, in: self.view, animated: true)
    }
    
    func setAddMode(){
        addMode = true
    }
    
    func setAddModePosponed(){
        submitTabBarItem.title = "Add"
        do{
            try showPicker()
        } catch let error {
            Alert.showErrorAlert(vc: self, message: error.localizedDescription)
        }
    }
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    
    func deleteContainer(){
        guard let containerId = containerToLoad else {
            Alert.showErrorAlert(vc: self, message: "Container is not created yet")
            return
        }
        
        try! AbsioSession.getSesssion().deleteContainer(containerId: containerId)
            .done { _ in
                self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        do{
            if (indexPath.section == 1 && indexPath.row == 0){
                try showPicker()
            }
            if (indexPath.section == 1 && indexPath.row == 1){
                if (currentData == nil){
                    Alert.showErrorAlert(vc: self, message: "Please load file first")
                    return
                }
                try showFile(filename: headerField.text ?? "default.file", data: currentData!)
            }
            if (indexPath.section == 2 && indexPath.row == 0){
                performSegue(withIdentifier: "access", sender: self)
            }
            if (indexPath.section == 0 && indexPath.row == 2){
                deleteContainer()
            }
            if (indexPath.section == 1 && indexPath.row == 2){
                if (currentData == nil){
                    Alert.showErrorAlert(vc: self, message: "Please load file first")
                    return
                }
                try showPreview(filename: headerField.text ?? "default.file", data: currentData!)
            }
        } catch let error {
            Alert.showErrorAlert(vc: self, message: error.localizedDescription)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "access"){
            let vc = (segue.destination as! AccessLevelListViewController)
            if (accessLevels != nil){
                vc.setAccessLevels(initialAccessLevels: accessLevels!)
            }
        }
    }
    
    func setAccessLevels(updatedAccessLevels : [AccessLevel]){
        accessLevels = updatedAccessLevels
    }
}
