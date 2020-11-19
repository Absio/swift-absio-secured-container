//
//  Container.swift
//  macOS-cli-crud-tool

import Foundation
import AbsioSDKOSX
import Swiftline
import PromiseKit

let containerTypeDescription =
"""

Container type will represent data format.
Types: File - will allow to specify path to file;
Data - data represented by text. By default will be used Data option.Test1234

Enter container type. Type could be 'File', 'Data' or empty
"""

func deleteContainer() {
    let containerID = ask("Enter container ID") { settings in
        settings.addInvalidCase("UUID string representation allowed only ") { value in
            return (UUID.init(uuidString: value) == nil)
        }
        settings.confirm = true
    }
    let givenId = UUID.init(uuidString: containerID)!
    
    do {
        try currentProvider?.deleteContainer(containerId: givenId)
            .done { _ in
            print("Container with id \(givenId) successfully deleted")
            showLoggedInMenu()
            }.catch {
                error in
                printError(error: error)
                showLoggedInMenu()
        }
    }
    catch {
        printError(error: error)
        showLoggedInMenu()
    }
}


func getContainerPayload () -> ContainerPayload {
    let containerType = ask(containerTypeDescription){ settings in
        settings.addInvalidCase("Type could be 'File', 'Data' or empty") { value in
            
            if(value != "File" || value != "Data")
            {
                return false
            }
            
            return !value.isEmpty
        }
    }
    
    var data: Data
    var header: String = ""
    
    switch containerType {
    case "File":
        let fileManager = FileManager.default
        let filePath = ask("Please specify path to file.") { settings in
            settings.addInvalidCase("You are entered wrong path, plaese try again!") { value in
                return !fileManager.fileExists(atPath: value)
            }
        }
        let fileName = fileManager.displayName(atPath: filePath)
        data = fileManager.contents(atPath: filePath)!
        header = fileName
    case "Data":
        let stringDataFromInput = ask("Please enter string data. Length should not be larger than 1000 symbols.") { settings in
            settings.addInvalidCase("Data is larger than 1000") { value in
                return value.count > 1000
            }
        }
        data = stringDataFromInput.toData()
    default:
        data = Data()
    }
    
    if(header.isEmpty){
        header = ask("Enter container header")
    }
    
    return ContainerPayload(header: header, data: data, containerType: containerType)
}

func createNewContainer() {
    let payload = getContainerPayload()
    do {
        let updateAccess = agree("Do you want to grant access to another user? (y/n)")
        var access: [AccessLevel] = []
        
        if(updateAccess){
            access.append(addAccessModifiers())
        }
        
        try currentProvider?.createContainer(content: payload.data, customHeaderObject: payload.header, accessLevels: access, type: payload.containerType)
            .done { securedContainer in
                print("Container was successfully created. Container ID: \(String(describing: securedContainer.metadata.containerId))")
            showLoggedInMenu()
            }.catch {
                error in
                printError(error: error)
                showLoggedInMenu()
        }
        
    } catch {
        printError(error: error)
        showLoggedInMenu()
    }
}

func addAccessModifiers() -> AccessLevel {
    let userId = ask("Enter userId") { settings in
        settings.addInvalidCase("UUID string representation allowed only ") { value in
            return (UUID.init(uuidString: value) == nil)
        }
    }
    
    let givenId = UUID.init(uuidString: userId)!;
    print("Available flags: \ndownloadContainer\ndecryptContainer\nuploadContainer\nviewAccess\nmodifyAccess\nmodifyContainerType\nviewContainerType\nreceiveAccessEvents\n")
    
    let permissionsString = ask("Please write flags separated with spaces. Or leave empty to set default.")
    
    let permissions = parsePermissionsFromString(params: permissionsString)
    
    let dateFormat = DateFormatter()
    dateFormat.dateFormat = "dd/mm/yyyy"
    
    let expirationDateString = ask("Please enter expiration date in format dd/mm/yyyy. Or leave empty") { settings in
        settings.addInvalidCase("Incorrect date format, please check format - dd/mm/yyyy ") { value in
            if(value.count > 0) {
                return dateFormat.date(from: value) == nil
            }
            return false;
        }
    }
    
    return AccessLevel(userId: givenId, permissions:permissions, expiresAt: dateFormat.date(from: expirationDateString))
}

func parsePermissionsFromString (params: String) -> Permissions? {
    
    if(params.isEmpty){
        return Permissions.defaultForReciepient()
    }
    let words = params.components(separatedBy: " ")
    var persissions: Permissions = []
    
    for word in words {
        
        switch word {
        case "downloadContainer":
            persissions.insert(Permissions.downloadContainer)
        case "decryptContainer":
            persissions.insert(Permissions.decryptContainer)
        case "uploadContainer":
            persissions.insert(Permissions.uploadContainer)
        case "viewAccess":
            persissions.insert(Permissions.viewAccess)
        case "modifyAccess":
            persissions.insert(Permissions.modifyAccess)
        case "modifyContainerType":
            persissions.insert(Permissions.modifyContainerType)
        case "viewContainerType":
            persissions.insert(Permissions.viewContainerType)
        case "receiveAccessEvents":
            persissions.insert(Permissions.receiveAccessEvents)
        default:
            return nil
        }
    }
    
    return persissions
}

func getAccessLevelsAsArray(accessLevels: [UUID : AbsioSDKOSX.AccessLevel]) -> [AbsioSDKOSX.AccessLevel] {
    return accessLevels.map{ $0.value }
}

func updateAccessForContainer(forExixtingUser: Bool = false) {
    let containerID = ask("Enter container ID") { settings in
        settings.addInvalidCase("UUID string representation allowed only ") { value in
            return (UUID.init(uuidString: value) == nil)
        }
    }
    
    let givenId = UUID.init(uuidString: containerID)!;
    
    do {
        try currentProvider?.getContainerMetadata(containerId: givenId).done { container in
            
            if(forExixtingUser)
            {
                printExistingUsersFromAccess(accessLevels: container.accessLevels!)
            }
            
            let newAccess = addAccessModifiers()
            var existingAccess = container.accessLevels!
            existingAccess[newAccess.userId] = newAccess
            
            try currentProvider?.updateContainerAccessLevels(containerId: givenId, accessLevels : getAccessLevelsAsArray(accessLevels: existingAccess)).done { _ in
                print("Access successfully updated for user: ", newAccess.userId as Any, "\n")
                showLoggedInMenu()
                }.catch {
                    error in
                    printError(error: error)
                    showLoggedInMenu()
            }
            }.catch {
                error in
                printError(error: error)
                showLoggedInMenu()
        }

    } catch {
        printError(error: error)
        showLoggedInMenu()
    }
}

func updateContainer() {
    
    let containerID = ask("Enter container ID") { settings in
        settings.addInvalidCase("UUID string representation allowed only ") { value in
            return (UUID.init(uuidString: value) == nil)
        }
    }
    
    let payload = getContainerPayload()
    
    let givenId = UUID.init(uuidString: containerID)!;
    
    do {
        
        let updateAccess = agree("Are you sure you want to update access? (y/n)")
        var access: [AccessLevel] = []
        
        if(updateAccess){
            access.append(addAccessModifiers())
        }
        
        try currentProvider?.updateContainer(containerId: givenId, content: payload.data, customHeaderObject: payload.header, accessLevels: access, type: payload.containerType).done { _ in
            print("Container was successfully updated")
            showLoggedInMenu()
            }.catch {
                error in
                printError(error: error)
                showLoggedInMenu()
        }
        
    } catch {
        printError(error: error)
        showLoggedInMenu()
    }
}

func getContainerWithGivenId () {
    
    let containerID = ask("Enter container ID") { settings in
        settings.addInvalidCase("UUID string representation allowed only ") { value in
            return (UUID.init(uuidString: value) == nil)
        }
    }
    let givenId = UUID.init(uuidString: containerID)!;
    
    do{
        try currentProvider?.getContainer(containerId: givenId).done { container in
            try printContainerInfo(container: container)
            showLoggedInMenu()
            }.catch {
                error in
                printError(error: error)
                showLoggedInMenu()
        }
    }
    catch {
        printError(error: error)
        showLoggedInMenu()
    }
}

func getLatestEvents () {
    do{
        try currentProvider?.getEvents()
            .done { events -> Void in
                printEvents(events: events)
                showLoggedInMenu()
        }.catch {
            error in
            print(error)
        }
    } catch {
        print(error)
        exit(0)
    }
}
