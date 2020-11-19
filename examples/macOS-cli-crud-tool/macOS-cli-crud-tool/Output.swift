//
//  Output.swift
//  macOS-cli-crud-tool

import Foundation
import RainbowSwift
import Swiftline
import AbsioSDKOSX

public func printError(error: Any) {
    switch error {
    case is AbsioError:
        let e = error as! AbsioError
        print(e.description.red)
    default:
        print("\(error)".red)
    }
}

public func printContainerInfo(container: Container) throws {
    
    print("Container Type: \(String(describing: container.containerMetadata?.type))")
    print("Container ID: \(String(describing: container.containerMetadata?.containerId))")
    print("Container Metadata:")
    print("Container Length: \(String(describing: container.containerMetadata?.length))")
    print("Created At: \(String(describing: container.containerMetadata?.createdAt))")
    print("Created By: \(String(describing: container.containerMetadata?.createdBy))")
    print("Modified At: \(String(describing: container.containerMetadata?.modifiedAt))")
    print("Modified By: \(String(describing: container.containerMetadata?.modifiedBy))")
    
    print("Permissions for given container:\n")
    for user in container.accessLevels! {
        
        print("---- Access For User:" + user.key.uuidString + "----")
        print("downloadContainer: ", user.value.permissions?.contains(.downloadContainer) as Any)
        print("decryptContainer: ", user.value.permissions?.contains(.decryptContainer) as Any)
        print("uploadContainer: ", user.value.permissions?.contains(.uploadContainer) as Any)
        print("viewAccess: ", user.value.permissions?.contains(.viewAccess) as Any)
        print("modifyAccess: ", user.value.permissions?.contains(.modifyAccess) as Any)
        print("modifyContainerType: ", user.value.permissions?.contains(.modifyContainerType) as Any)
        print("viewContainerType: ", user.value.permissions?.contains(.viewContainerType) as Any)
        print("receiveAccessEvents: ", user.value.permissions?.contains(.receiveAccessEvents) as Any)
        print("----------\n")
    }
    print("\n")
    
    var headerValue:String?
    do{
        headerValue = try container.header?.getObject(headerType: String.self)
    }
    catch{
        print(error)
    }

    if(container.containerMetadata?.type == "File") {
        let fileName = headerValue

        let openFile = agree("Container contains File as content - file name \(String(describing: fileName)). would you like to open it with default program? (y/n)")
        if(openFile) {
            let fileFilePathWithName = getDocumentsDirectory().appendingPathComponent(fileName!)
            try container.content?.write(to: fileFilePathWithName)
            NSWorkspace.shared.openFile(fileFilePathWithName.path)
        }
    }
    else if(container.containerMetadata?.type == "Data") {
        print("Container Data in string representation:\n\(String(describing: String(data: container.content!, encoding: String.Encoding.utf8)))\n ----- End -----")
        print("Header Data: \(String(describing: headerValue))")
    }
    else {
        print("Header Data: \(String(describing: headerValue))")
    }
}

func printEvents (events: [Event]) {
    for event in events {
        print("---- event id: ", event.eventId as Any, "----")
        print("event type:", event.type as Any)
        print("action: ", event.action!.rawValue)
        print("container id: ", event.containerId as Any)
        print("container type: ", event.containerType as Any)
        print("related user Id: ", event.relatedUserId as Any)
        print("container modified at: ", event.containerModifiedAt as Any)
        print("container expires at: ", event.containerExpiredAt as Any)
        print("date: ", event.date as Any)
        print("---------\n")
    }
}

func printExistingUsersFromAccess(accessLevels: [UUID : AbsioSDKOSX.AccessLevel]) {
    print("---- Users ----")
    for user in accessLevels {
        print(user.key.uuidString, "\n")
    }
}
