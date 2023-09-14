//
//  AdRequest.swift
//  FOAV
//
//  Created by hoonKim on 2021/08/18.
//  Copyright © 2021 hoon Kim. All rights reserved.
//

import Foundation

enum AdDiff: String, Codable {
  case 게시글
  case 상점
}

enum AdTypeDiff: String, Codable {
  case 동
  case 구
  case 시
}

struct AdRegistRequest: Codable {
  let shopId: Int?
  let snsId: Int?
  let address: String
  let type: AdTypeDiff
}

struct AdListRequest: Codable {
  let latitude: String?
  let longitude: String?
  let diff: AdDiff?
  let type: AdTypeDiff?
  let userId: Int?
  
  init(
    latitude: String? = nil,
    longitude: String? = nil,
    diff: AdDiff? = nil,
    type: AdTypeDiff? = nil,
    userId: Int? = nil
  ) {
    self.latitude = latitude
    self.longitude = longitude
    self.diff = diff
    self.type = type
    self.userId = userId
  }
}
