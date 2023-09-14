//
//  SNSResponse.swift
//  FOAV
//
//  Created by hoonKim on 2020/08/26.
//  Copyright © 2020 hoon Kim. All rights reserved.
//

import Foundation

struct SNSListResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  let list: [SnsList]
}

struct SnsList: Codable {
  let id: Int
  let title: String
  let wishCount, commentCount, viewCount: Int
  let createdAt: String
  let user: SnsUserData
  let boardImages: [BoardImage]
}

struct BoardImage: Codable {
  let id: Int
  let name: String
}

struct SnsUserData: Codable {
  let loginId: String
  let id: Int?
  let profile: String?
}


struct SNSRegistResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  let data: SNSRegist
}

struct SNSRegist: Codable {
  let boardId: Int
}


struct SNSDetailResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  let data: SNSDetail
}

struct SNSDetail: Codable {
  let id: Int
  let title, content: String
  let youtube: String?
  let code: String
  let isWish: Bool
  let viewCount, wishCount, commentCount: Int
  let createdAt: String
  let userId: Int
  let user: SnsUserData
  let boardImages: [BoardImage]
}


struct SNSCommentListResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  let list: [SnsCommentList]
}

struct SnsCommentList: Codable {
  let id, userId: Int
  let isWish: Bool
  let content: String
  let wishCount: Int
  let createdAt: String
  let user: SnsUserData
}
