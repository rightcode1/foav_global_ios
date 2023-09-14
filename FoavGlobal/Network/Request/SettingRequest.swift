//
//  SettingRequest.swift
//  FOAV
//
//  Created by hoon Kim on 17/10/2019.
//  Copyright © 2019 hoon Kim. All rights reserved.
//

import Foundation

struct ChangeUserInfoRequest: Codable {
    var name: String
    var birth: String
    var email: String
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case birth = "birth"
        case email = "email"
    }
}
struct NewsDetailRequest: Codable {
    var newsId: Int
    
    enum CodingKeys: String, CodingKey {
        case newsId = "newsId"
    }
}

struct NoticeDetailRequest: Codable {
    var noticeId: Int
    
    enum CodingKeys: String, CodingKey {
        case noticeId = "id"
    }
}

struct InquiryRequest: Codable {
    var title: String
    var content: String
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case content = "content"
    }
}

struct NotificationRequest: Codable {
    var notificationToken: String
}
