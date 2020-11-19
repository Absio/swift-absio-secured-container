//
//  Menus.swift
//  macOS-cli-crud-tool

import Foundation
import Swiftline
import RainbowSwift
import AbsioSDKOSX

enum Commands: String {
    
    case Login = "Login" // +
    case Exit = "Exit" // +
    case Register = "Register New User" // +
    case GetReminder = "Get Reminder" // +
    case GetEvents = "Get Events" // +
    case CreateContainer = "Create Container" // +
    case GetContainer = "Get Container" // +
    case UpdateContainer = "Update Container"
    case DeleteContainer = "Delete Container"//+
    case LogOut = "Log Out"// +
    case TryAgain = "Try Again" //+
    case ManageUser = "Manage User" //+
    case ChangeCredentials = "Change Credentials" //+
    case DeleteUser = "Delete User" //+
    case GoBack = "Go Back"//++
    case SelectProvider = "Select Provider" // ++

    case GrantAccessForNewUser = "Grant Access For New User"
    case UpdateAccessForExistingUser = "Update Access For Existing User"
}

enum Providers: String {
    case ServerProvider = "Server Provider"
    case OfsProvider = "OFS Provider"
    case CombinedProvider = "Combined Provider"
}

func manageUserMenu() {
    print("\nUser Management:\n")
    
    let selectedMenuItem = choose("Please choose an option  ",
                                  choices:
        Commands.ChangeCredentials.rawValue,
                                  Commands.DeleteUser.rawValue,
                                  Commands.GoBack.rawValue)
    
    switch selectedMenuItem {
    case Commands.ChangeCredentials.rawValue:
        changeCredentials()
    case Commands.DeleteUser.rawValue:
        deleteCurrentUser()
    default:
        showLoggedInMenu()
    }
}

func showUpdateContainerMenu() {
    let selectedMenuItem = choose("Please choose an option  ",
                                  choices:
                                  Commands.UpdateContainer.rawValue,
                                  Commands.GrantAccessForNewUser.rawValue,
                                  Commands.UpdateAccessForExistingUser.rawValue,
                                  Commands.GoBack.rawValue)
    
     switch selectedMenuItem {
     case Commands.UpdateContainer.rawValue:
        updateContainer()
     case Commands.GrantAccessForNewUser.rawValue:
        updateAccessForContainer(forExixtingUser: false)
     case Commands.UpdateAccessForExistingUser.rawValue:
        updateAccessForContainer(forExixtingUser: true)
     default:
        showLoggedInMenu()
     }
}

func showLoggedInMenu() {
    let selectedMenuItem = choose("Please choose an option  ",
                                  choices:
                                  Commands.GetContainer.rawValue,
                                  Commands.CreateContainer.rawValue,
                                  Commands.DeleteContainer.rawValue,
                                  Commands.UpdateContainer.rawValue,
                                  Commands.GetEvents.rawValue,
                                  Commands.ManageUser.rawValue,
                                  Commands.LogOut.rawValue)
    switch selectedMenuItem {
        
    case Commands.LogOut.rawValue:
        logOut()
    case Commands.GetContainer.rawValue:
        getContainerWithGivenId()
    case Commands.GetEvents.rawValue:
        getLatestEvents()
    case Commands.CreateContainer.rawValue:
        createNewContainer()
    case Commands.DeleteContainer.rawValue:
        deleteContainer()
    case Commands.UpdateContainer.rawValue:
        showUpdateContainerMenu()
    case Commands.GetEvents.rawValue:
        getLatestEvents()
    case Commands.ManageUser.rawValue:
        manageUserMenu()
    default:
        logOut()
    }
}

func tryAgainOrExit(function: ()  -> Void) {
    let startSession = choose("Please choose an option  ",
                              choices:
                              Commands.TryAgain.rawValue,
                              Commands.Exit.rawValue)
    
    switch startSession {
    case Commands.TryAgain.rawValue:
        function()
    default:
        exit(0)
    }
}

func runMainMenu() {
    mainLogo()
    let startSession = choose("Please choose an option  ", choices:
                            Commands.SelectProvider.rawValue,
                            Commands.Login.rawValue,
                            Commands.GetReminder.rawValue,
                            Commands.Register.rawValue,
                            Commands.Exit.rawValue)
    switch startSession {
    case Commands.SelectProvider.rawValue:
        selectActiveProvider()
    case Commands.Login.rawValue:
        loginWithCredentials()
    case Commands.GetReminder.rawValue:
        getReminderForUser()
    case Commands.Register.rawValue:
        registerNewUser()
    default:
        exit(0)
    }
}

func mainLogo(){
    let name = "Secured Container CRUD Utility".applyingColor(Color.cyan)
    let logo = "ABSIO".applyingColor(Color.cyan)
    let note = "NOTE: Please note you can choose data provider before start. Default provider - server provider."
    print(logo)
    print(name)
    print("\n" + note + "\n")
}
