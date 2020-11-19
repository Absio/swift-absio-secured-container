//
//  ContainerInfo.swift
//  AbsioCRUD
//
//  Created by admin on 4/12/18.
//  Copyright © 2018 Absio. All rights reserved.
//

import Foundation

class ContainerInfo {
    public var type : String
    public var date : String
    public var header : String
    public var id : UUID
    
    init(id : UUID, header : String, date : String, type : String) {
        self.id = id
        self.header = header
        self.date = date
        self.type = type
    }
}
