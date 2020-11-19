//
//  Provider.swift
//  macOS-cli-crud-tool


import Foundation
import AbsioSDKOSX
import Swiftline

var currentProvider: ServerProvider?

// TODO change default provider to serverCache
func initWithDefaultProvider() {
    initWithProvider(providerType: ServerProvider.self)
}

func initWithProvider<T>(providerType: T.Type) {
    
    do {
        let serverUrl = URL(string: serverURL)
        if providerType == ServerProvider.self{
            currentProvider = try ServerProvider(apiKey: apiKey!, serverUrl: serverUrl!, applicationName: applicationName)
        }
        
        if currentProvider == nil {
            printError(error: "Something goes wrong, check setting and try again, session is nil")
            runMainMenu()
        }
    } catch {
        printError(error: error)
    }
}

func selectActiveProvider() {
    
    if currentProvider != nil {
        currentProvider = nil
    }
    
    let providersInfo =
    """

    Please select a Provider:
      - Server Provider: all data is stored by the Broker application server
      - OFS Provider: all data is stored locally in the Obfuscating File System
      - Combined Provider: all data is stored by the Broker application server and cached locally

    """;
    
    print(providersInfo)
    
    let selectedProvider = choose("", choices: Providers.ServerProvider.rawValue,
                                               Providers.OfsProvider.rawValue,
                                               Providers.CombinedProvider.rawValue)
    
    switch selectedProvider {
    case Providers.ServerProvider.rawValue:
        initWithProvider(providerType: ServerProvider.self)
    case Providers.OfsProvider.rawValue:
        initWithProvider(providerType: OfsProvider.self)
    case Providers.CombinedProvider.rawValue:
        initWithProvider(providerType: ServerCacheOfsProvider.self)
    default:
        initWithProvider(providerType: ServerProvider.self)
    }
    runMainMenu()
}


