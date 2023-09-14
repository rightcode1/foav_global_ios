//
//  ServiceResponse.swift
//  FOAV
//
//  Created by hoon Kim on 21/10/2019.
//  Copyright © 2019 hoon Kim. All rights reserved.
//

import Foundation

struct ServiceGroupListResponse: Codable {
    let code: Int
    let result: Bool
    let resultMsg: String
    let serviceGroupList: [ServiceGroup]
}
struct ServiceGroup: Codable {
    let zoneId: Int
    let createdAt: String
    let zone: String
    let count: Int
}
struct ServiceGroupDetailResponse: Codable {
    let code: Int
    let result: Bool
    let resultMsg: String
    let images: [String]
    let serviceGroupDetails: [ServiceGroupDetail]
}
struct ServiceGroupDetail: Codable {
    let userName: String
    let userBirth: String
    let totalTime: String
}
struct ZoneOpenResponse: Codable {
    var code: Int
    var result: Bool
    var resultMsg: String
    var zone:  Zone
    
    struct Zone: Codable {
        var id: Int
        var zone: String
    }
}

struct ZoneCloseResponse: Codable {
    var code: Int
    var result: Bool
    var resultMsg: String
}

struct ZoneListResponse: Codable {
    let code: Int
    let result: Bool
    let resultMsg: String
    let zones: [Zone]?
}

struct Zone: Codable {
    let id: Int?
    let zone: String?
    let manager: Manager?
    
    struct Manager: Codable {
        let name: String?
        let createdAt: String?
        let updateAt: String?
        let deletedAt: String?
        let userId: Int?
        let centerId: Int?
    }
}

struct ZoneStartResponse: Codable {
    let code: Int
    let result: Bool
    let resultMsg: String
}

struct ZoneStatusResponse: Codable {
    let code: Int
    let result: Bool
    let resultMsg: String
    let status: Status
    
    struct Status: Codable {
        let diff: String
        let title: String
        let content: String
        
    }
}

struct ZoneEndResponse: Codable {
    let code: Int
    let result: Bool
    let resultMsg: String
}

struct ZoneHistoryResponse: Codable {
    let code: Int
    let result: Bool
    let resultMsg: String
    let zone: String
    let history: History
    
}

struct History: Codable {
    let count: Int
    let rows: [HistoryRows]?
    
    struct HistoryRows: Codable {
        let startDate: String?
        let endDate: String?
        let user: User?
        
        struct User: Codable {
            let name: String?
            let birth: String?
        }
    }
}

struct ZoneCloseCheckResponse: Codable {
    let code: Int
    let result: Bool
    let resultMsg: String
    let CloseCheck: Bool
}


struct ServicePortalListResponse: Codable {
    let code: Int
    let result: Bool
    let resultMsg: String
    let list: [ServicePortalList]
}

struct ServicePortalList: Codable {
    let id: Int
    let title, date, area: String
    let ageKind: String
    let time, join, url: String
    let region: String
    let regionDetail: String
    let age: String
    let kind: String
    let kindDetail, createdAt: String
}



struct ServiceGuideImageResponse: Codable {
    let code: Int
    let result: Bool
    let resultMsg: String
    let data: ServiceGuideImage
  
  struct ServiceGuideImage: Codable {
    let thumbnail: String
  }
}
