//
//  SnsV2Response.swift
//  FOAV
//
//  Created by hoonKim on 2021/08/16.
//  Copyright © 2021 hoon Kim. All rights reserved.
//

import Foundation

// MARK: - SnsV2ListResponse
struct SnsV2ListResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  var list: [SnsV2List]?
}

// MARK: - SnsV2MainListResponse
struct SnsV2MainListResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  var list: SnsV2MainList
}

// MARK: - SnsV2MainListResponse
struct SnsV2MainList: Codable {
  var rows: [SnsV2List]
}

// MARK: - SnsV2List
struct SnsV2List: Codable {
  let id: Int
  let userId: Int
  let title: String
  let price: Int?
  let category: String?
  let tel: String?
  let content: String
  var wishCount, commentCount: Int
  var isWish: Bool
  let createdAt: String
  let images: [Image]
  let user: UserInfo
  var isOpenContent: Bool?
}

struct SnsV2RegistResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  let data: SnsIdData?
}

struct SnsIdData: Codable {
  let snsId: Int
}

// MARK: - SnsV2CommentListResponse
struct SnsV2CommentListResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  let list: [SnsV2CommentList]
}

// MARK: - List
struct SnsV2CommentList: Codable {
  let id, userId: Int
  let content: String
  let depth: Int
  let createdAt: String
  let user: UserInfo
  
}
