//
//  AbsioSession.swift
//  AbsioCRUD
//
//  Created by admin on 4/12/18.
//  Copyright © 2018 Absio. All rights reserved.
//

import Foundation
import UIKit
import AbsioSDKiOS
import PromiseKit

class AbsioSession {
    
    static let apiKey: String = ""
    static let apiPath: String = ""
    static let appName: String = "AbsioSdk iOs github example"
    
    static private var session : ServerProvider?
    
    static public func getSesssion() -> ServerProvider{
        return session!
    }
    
    static public func getUserId() -> UUID{
        return try! getSesssion().getUserId()
    }
    
    private static func initSession() -> ServerProvider{
        return try! ServerProvider(apiKey: UUID(uuidString : apiKey)!, serverUrl: URL(string: apiPath)!, applicationName: appName)
    }
    
    static public func login(userId : UUID, password : String?, passphrase : String?) throws -> Promise<Void>{
        UserDefaults.standard.set(userId.uuidString, forKey: "id")
        session = initSession()
        return try getSesssion().logIn(userId: userId, password: password, passphrase: passphrase).asVoid()
    }
    
    static public func register(password : String, passphrase : String, reminder : String?) throws -> Promise<String> {
        session = initSession()
        return try getSesssion().register(password: password, passphrase: passphrase, reminder: reminder)
            .map{ _ -> String in
                let id = try getSesssion().getUserId().uuidString
                UserDefaults.standard.set(id, forKey: "id")
                return id
        }
    }
    
    static public func logout(){
        try! session?.logout()
        session = nil
    }
}
