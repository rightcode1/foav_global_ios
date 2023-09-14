//
//  ShopRequest.swift
//  FOAV
//
//  Created by hoonKim on 2021/08/15.
//  Copyright © 2021 hoon Kim. All rights reserved.
//

import Foundation

// MARK: - ShopRegistRequest
struct ShopRegistRequest: Codable {
  let name, category, intro, homepage: String
  let tel, time, address, addressDetail: String
  let latitude, longitude: String
  let isPackage: Bool
  let isTumbler: Bool
  let isCurrency: Bool
}

// MARK: - ShopListRequest
struct ShopListRequest: Codable {
  let category: String?
  let isCoupon: String?
  let userId: Int?
  let search: String?
  let latitude, longitude: String?
  init(
    category: String? = nil,
    isCoupon: String? = nil,
    userId: Int? = nil,
    search: String? = nil,
    latitude: String? = nil,
    longitude: String? = nil
  ) {
    self.category = category
    self.isCoupon = isCoupon
    self.userId = userId
    self.search = search
    self.latitude = latitude
    self.longitude = longitude
  }
}


struct ShopReviewRegistRequest: Codable {
  let shopId: Int
  let content: String
  let rate: Double
}
