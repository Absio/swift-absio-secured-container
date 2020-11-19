//
//  main.swift
//  macOS-cli-crud-tool

import Foundation
import AbsioSDKOSX

let serverURL = ""
let apiKey = UUID.init(uuidString: "");
let applicationName = "AbsioSdk macOs github example"


initWithDefaultProvider()
runMainMenu()
RunLoop.main.run(until: Date.distantFuture)

