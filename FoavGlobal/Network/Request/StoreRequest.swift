//
//  StoreRequest.swift
//  FOAV
//
//  Created by hoon Kim on 23/12/2019.
//  Copyright © 2019 hoon Kim. All rights reserved.
//

import Foundation

struct RegistStoreRequest: Codable {
  let name: String
  let address: String
  let addressDetail: String
  let tel: String
  let discount: String
  let managerTel: String
  let url: String
  let content: String
  let latitude: String
  let longitude: String
}

struct RegistStoreRequestNoneUrl: Codable {
  let name: String
  let address: String
  let addressDetail: String
  let tel: String
  let discount: String
  let managerTel: String
  let content: String
  let latitude: String
  let longitude: String
}

struct RegistStoreRequestNoneDiscount: Codable {
  let name: String
  let address: String
  let addressDetail: String
  let tel: String
  let managerTel: String
  let url: String
  let content: String
  let latitude: String
  let longitude: String
}

struct RegistStoreRequestNoneDiscountAndUrl: Codable {
  let name: String
  let address: String
  let addressDetail: String
  let tel: String
  let managerTel: String
  let content: String
  let latitude: String
  let longitude: String
}

struct RegistStoreThumbnailRequest: Codable {
  let storeId: String
  let image: Data
  enum Codingkeys: String, CodingKey {
    case storeId = "storeId"
  }
}

struct StoreListRequest: Codable {
  let latitude: String?
  let longitude: String?
  let delivery: String?
  let search: String?
  let category: String?
  let carbonCategory: String?
  let companyId: Int?
  
  init(
    latitude: String? = nil,
    longitude: String? = nil,
    delivery: String? = nil,
    search: String? = nil,
    category: String? = nil,
    carbonCategory: String? = nil,
    companyId: Int? = nil
  ) {
    self.latitude = latitude
    self.longitude = longitude
    self.delivery = delivery
    self.search = search
    self.category = category
    self.carbonCategory = carbonCategory
    self.companyId = companyId
  } 
}

struct StoreListDetailRequest: Codable {
  let storeId: Int
  let latitude: String
  let longitude: String
}
struct ReviewRegistRequest: Codable {
  let storeId: Int
  let content: String
  let rate: Double
  let orderId: Int?
}
struct ReviewListRequest: Codable {
  let storeId: Int
}
struct ReviewDelete: Codable {
  let reviewId: Int
}
