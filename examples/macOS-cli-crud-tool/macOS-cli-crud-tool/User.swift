//
//  User.swift
//  macOS-cli-crud-tool

import Foundation
import AbsioSDKOSX
import Swiftline
import PromiseKit

public func loginWithCredentials() {
    let userId = ask("Enter userId") {settings in
        settings.addInvalidCase("UUID string representation allowed only ") { value in
            return (UUID.init(uuidString: value) == nil)
        }
    }
    
    let password = ask("Enter password") {settings in
        settings.addInvalidCase("Password should not be empty") { value in
            value.isEmpty
        }
    }
    
    let passphrase = ask("Enter passphrase") {settings in
        settings.addInvalidCase("Passphrase should not be empty") { value in
            value.isEmpty
        }
    }
    
    do {
        
        if(currentProvider == nil) {
            initWithDefaultProvider()
        }
        
        let uuid = UUID.init(uuidString: userId)!;
        try currentProvider?.logIn(userId: uuid, password: password, passphrase: passphrase).done {
            _ in
            showLoggedInMenu()
            }.catch {
                error in
                printError(error: error)
                runMainMenu()
        }
    } catch {
        printError(error: error)
        runMainMenu()
    }
}

func changeCredentials() {
    
    let newPassword = ask("Enter new password") {settings in
        settings.addInvalidCase("Password should not be empty") { value in
            value.isEmpty
        }
    }
    
    let newPassphrase = ask("Enter new passphrase") {settings in
        settings.addInvalidCase("Passphrase should not be empty") { value in
            value.isEmpty
        }
    }
    
    let newReminder = ask("Enter reminder") { settings in
        settings.addInvalidCase("Reminder should not be empty") { value in
            value.isEmpty
        }
    }
    do {
        try currentProvider?.changeCredentials(password: newPassword, passphrase: newPassphrase, reminder: newReminder).done {
            _ in
            logOut()
            }.catch {
                error in
                printError(error: error)
        }
    } catch {
        printError(error: error)
        showLoggedInMenu()
    }
}

func deleteCurrentUser() {
    let deleteUser = agree("Are you sure, you want to delete current user? (y/n)")
    
    if(deleteUser) {
        do{
            try currentProvider?.deleteUser().done {
                _ in
                print("User successfully  deleted")
                logOut()
                } .catch {
                    error in
                    printError(error: error)
            }
        } catch {
            printError(error: error)
            manageUserMenu()
        }
    }
    else{
        manageUserMenu()
    }
}

func getReminderForUser(){
    
    let containerID = ask("Enter User ID") { settings in
        settings.addInvalidCase("UUID string representation allowed only ") { value in
            return (UUID.init(uuidString: value) == nil)
        }
    }
    
    let givenId = UUID.init(uuidString: containerID)!;
    
    do {
        try currentProvider?.getReminder(userId: givenId)
            .done { reminder in
            print("UserId: \(givenId) \nReminder: \(reminder)")
            runMainMenu()
            }.catch {
                error in
                printError(error: error)
        }
    } catch {
        printError(error: error)
        runMainMenu()
    }
}

func registerNewUser() {
    
    let password = ask("Enter password") {settings in
        settings.addInvalidCase("Password should not be empty") { value in
            value.isEmpty
        }
    }
    
    let passphrase = ask("Enter passphrase") {settings in
        settings.addInvalidCase("Passphrase should not be empty") { value in
            value.isEmpty
        }
    }
    
    let reminder = ask("Enter reminder") { settings in
        settings.addInvalidCase("Reminder should not be empty") { value in
            value.isEmpty
        }
    }
    
    if(currentProvider == nil) {
        initWithDefaultProvider()
    }
    
    do {
        try currentProvider!.register(password: password, passphrase: passphrase, reminder: reminder).map { ring -> String in
            let uuid = try currentProvider?.getUserId()
            return uuid!.uuidString
            }.done { userId in
                print("Registered new user: \(userId)".blue)
                runMainMenu()
            }.catch {
                error in
                printError(error: error)
                tryAgainOrExit(function: registerNewUser)
        }
    } catch {
        printError(error: error)
        runMainMenu()
    }
}

func logOut() {
    do{
        try currentProvider?.logout().done { _ in
            currentProvider = nil
            runMainMenu()
        }.catch { error in
            printError(error: error)
            tryAgainOrExit(function: logOut)
        }
    }
    catch {
        printError(error: error)
        runMainMenu()
    }
}
