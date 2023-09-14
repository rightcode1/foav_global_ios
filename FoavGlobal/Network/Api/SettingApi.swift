//
//  SettingApi.swift
//  FOAV
//
//  Created by hoon Kim on 17/10/2019.
//  Copyright © 2019 hoon Kim. All rights reserved.
//

import Foundation
import Alamofire


enum SettingApi: ApiRouter {
    
    
    case news
    case foavnews
    case newsDetail
    case serviceMainNewsList
    case serviceNews
    case serviceNewsDetail
    case notice
    case noticeDetail
    case partnershipList
    case partnershipDetail
    case inquiry(param: InquiryRequest)
    case sendNotificationToken(param: NotificationRequest)
    case lookUpNotificationStatus
    case switchNotification
    

    var method: HTTPMethod{
        switch self{
        case
        .inquiry,
        .sendNotificationToken:
            return .post
        case .notice,
             .noticeDetail,
             .news,
             .foavnews,
             .newsDetail,
             .serviceNews,
             .serviceMainNewsList,
             .serviceNewsDetail,
             .lookUpNotificationStatus,
             .partnershipList,
             .partnershipDetail,
             .switchNotification:
            return .get

        }
    }

    var path: String{
        switch self{
        case .news : return "/news"
        case .foavnews : return "/news/mainList"
        case .newsDetail : return "/news/\(newsDetailId)"
        case .inquiry : return "/inquiry"
        case .notice : return "/notice"
        case .noticeDetail : return "/notice/\(noticeDetailId)"
        case .sendNotificationToken : return "/notification"
        case .lookUpNotificationStatus : return "/notification/status"
        case .switchNotification : return "/notification/switch"
        case .partnershipList : return "/partnership"
        case .partnershipDetail : return "/partnership/\(partnershipId)"
        case .serviceNews : return "/serviceNews/mainList"
        case .serviceMainNewsList : return "/serviceNews"
        case .serviceNewsDetail : return "/serviceNews/\(serviceNewsId)"
        

        }
    }
    //    var request = URLRequest(url: URL(string: usersDataPoint)!)
    //    request.addValue("Token \(tokenString)", forHTTPHeaderField: "Authorization")
    func urlRequest() throws -> URLRequest {

        let url = try baseUrl.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue

        switch self {
        case .news:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
        case .foavnews:
            urlRequest = try URLEncoding.queryString.encode(urlRequest, with: ["english": "\(true)"])
            urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
        case .newsDetail :
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
        case .partnershipList:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
        case .partnershipDetail:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
        case .serviceNews:
            urlRequest = try URLEncoding.queryString.encode(urlRequest, with: ["english": "\(true)"])
            urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
        case .serviceMainNewsList:
            urlRequest = try URLEncoding.queryString.encode(urlRequest, with: ["english": "\(true)"])
            urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
        case .serviceNewsDetail:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
        case .notice:
            urlRequest = try URLEncoding.queryString.encode(urlRequest, with: ["english": "\(true)"])
            urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
        case .noticeDetail :
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
        case .inquiry(let param):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: makeParams(param))
            urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
        case .sendNotificationToken(let param):
            urlRequest = try URLEncoding.httpBody.encode(urlRequest, with: makeParams(param))
            urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
        case .lookUpNotificationStatus :
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
            urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
        case .switchNotification :
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
            urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")

        }
        return urlRequest
    }

    #if DEBUG
    var fakeFile: String? {
        return nil
    }
    #endif
}
