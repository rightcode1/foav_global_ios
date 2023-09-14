//
//  SnsV2Request.swift
//  FOAV
//
//  Created by hoonKim on 2021/08/16.
//  Copyright © 2021 hoon Kim. All rights reserved.
//

import Foundation

struct SnsV2ListRequest: Codable {
  var page: Int? = nil
  var limit: Int? = nil
  var category: String? = nil
  
  init(
    page: Int? = nil,
    limit: Int? = nil,
    category: String? = nil
  ) {
    self.page = page
    self.limit = limit
    self.category = category
  }
}

struct RegistSnsV2Request: Codable {
  let title: String
  let price: Int
  let tel: String?
  let content: String
  let category: String?
}

struct RegistSnsV2CommentRequest: Codable {
  let snsId: Int
  let content: String
  let snsCommentId: Int?
}
