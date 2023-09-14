//
//  ServiceRequest.swift
//  FOAV
//
//  Created by hoon Kim on 21/10/2019.
//  Copyright © 2019 hoon Kim. All rights reserved.
//

import Foundation

struct ServiceGruopListRequest: Codable {
    let date: String
    enum CodingKeys: String, CodingKey {
        case date = "date"
    }
}

struct ServiceGruopDetailRequest: Codable {
    let zoneId: Int
    enum CodingKeys: String, CodingKey {
        case zoneId = "zoneId"
    }
}

struct ZoneOpenRequest: Codable {
    var zone: String
    var latitude: String
    var longitude: String
    
    enum CodingKeys: String, CodingKey {
        case zone = "zone"
        case latitude = "latitude"
        case longitude = "longitude"
    }
}

struct ZoneStatusRequest: Codable {
    let id: String
    let diff: String
    
    enum CodingKeys: String, CodingKey {
        case id = "zoneId"
        case diff = "diff"
    }
    
}

struct ZoneCloseRequest: Codable {
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case id = "zoneId"
    }
}

struct ZoneListRequest: Codable {
    var login: Bool
}

struct ZoneStartRequest: Codable {
    var zoneId: String
    
    enum CodingKeys: String, CodingKey {
        case zoneId = "zoneId"
    }
}

struct ZoneEndRequest: Codable {
    var zoneId: String
    
    enum CodingKeys: String, CodingKey {
        case zoneId = "zoneId"
    }
}

struct ZoneHistoryRequest: Codable {
    var zoneId: String
    
    enum CodingKeys: String, CodingKey {
        case zoneId = "zoneId"
    }
}

struct ZoneCloseCheckRequest: Codable {
    var zoneId: String
    
    enum CodingKeys: String, CodingKey {
        case zoneId = "zoneId"
    }
}

struct ServicePortalListRequest: Codable {
  let region: String?
  let regionDetail: String?
  let age: String?
  let kind: String?
  let kindDetail: String?
}

