//
//  Utils.swift
//  AbsioCRUD
//
//  Created by admin on 4/11/18.
//  Copyright © 2018 Absio. All rights reserved.
//

import Foundation
import UIKit

class Alert {
    static var alert : UIAlertController?
    
    public static func show(vc : UIViewController, title : String, message : String) {
        alert?.dismiss(animated: false, completion: nil)
        alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert!.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        vc.present(alert!, animated: true, completion: nil)
    }
    
    public static func showErrorAlert(vc : UIViewController, message : String ){
        Alert.show(vc: vc, title: "Error", message: message)
    }
    
    public static func showConfirm(vc : UIViewController, title : String, message : String, confirmSelector: @escaping() -> Void) {
        alert?.dismiss(animated: false, completion: nil)
        alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert!.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) { (action) in confirmSelector() })
        alert!.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        vc.present(alert!, animated: true, completion: nil)
    }
}

class LoadingView {
    static var alert : UIAlertController?
    
    static func start(vc : UIViewController){
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        alert = UIAlertController(title: nil, message: "Loading...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        
        alert!.view.addSubview(loadingIndicator)
        vc.present(alert!, animated: true, completion: nil)
    }
    
    static func stop(){
        alert?.dismiss(animated: true, completion: nil)
        UIApplication.shared.endIgnoringInteractionEvents()
    }
}
