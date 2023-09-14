//
//  settingResponse.swift
//  FOAV
//
//  Created by hoon Kim on 17/10/2019.
//  Copyright © 2019 hoon Kim. All rights reserved.
//

import Foundation


struct ChangeUserInfoResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
}
struct PartnershipResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  let partnershipList: [PartnershipList]
}
struct PartnershipDetailResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  let partnership: NewsDetail
}

struct ServiceNewsResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  let serviceNewsList: [ListRows]
}
struct ServiceNewsDetailResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  let serviceNews: NewsDetail
}

struct NewsResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  let newsList: News
}

struct NewsFoavResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  let newsList: [RowsNews]
}

struct ServiceMainNewsListResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  let serviceNewsList: News
}

struct MainNewsList: Codable {
  let id: Int
  let sortCode: Int
  let title: String
  let createdAt: String
}

struct News: Codable {
  let count: Int
  let rows: [RowsNews]
  

}
struct RowsNews: Codable {
  let id: Int
  let sortCode: Int
  let title: String
  let createdAt: String
}
struct FoavNews: Codable {
    let id: Int
    let sortCode: Int
    let title: String
    let createdAt: String
}
struct ListRows: Codable {
  let id: Int
  let sortCode: Int
  let thumbnail: String
  let title: String
  let thumbnailName: String
}

struct PartnershipList: Codable {
  let id: Int
  let sortCode: Int
  let title: String
  let thumbnail: String
  let createdAt: String
}

struct NewsDetailResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  let news: NewsDetail
}

struct NewsDetail: Codable {
  let id: Int
  let title: String
  let content: String
  let sortCode: Int
  let thumbnail: String
  let image: String?
  let createdAt: String
  
  enum CodingKeys: String, CodingKey {
    case id = "id"
    case title = "title"
    case content = "content"
    case sortCode = "sortCode"
    case thumbnail = "thumbnail"
    case image = "image"
    case createdAt = "createdAt"
  }
}
struct NoticeResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  let notices: Notices
  
}

struct Notices: Codable {
  let count: Int
  let rows: [NoticeRows]
  
  struct NoticeRows: Codable {
    let id: Int
    let title: String
    let createdAt: String
  }
}

struct NoticeDetailResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  let notice: NoticeDetail
  
}
struct NoticeDetail: Codable {
  let id: Int
  let title: String
  let content: String
  let createdAt: String
  
  
  enum CodingKeys: String, CodingKey {
    case id = "id"
    case title = "title"
    case content = "content"
    case createdAt = "createdAt"
  }
}

struct InquiryResoponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
}
struct NotificationResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
}
struct NotificationStatusResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  let user: PushUser
  
  struct PushUser: Codable {
    let notification: String
  }
}
struct NotificationSwitchResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  let user: PushUser
  
  struct PushUser: Codable {
    let id: Int
    let notification: String
    let updateAt: String
  }
  
}
