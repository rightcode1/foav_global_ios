//
//  StoreResponse.swift
//  FOAV
//
//  Created by hoon Kim on 23/12/2019.
//  Copyright © 2019 hoon Kim. All rights reserved.
//

import Foundation

struct RegistStoreReponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  let store: Store
  
}
struct RegistThumbnailResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
}
struct Store: Codable {
  let address: String
  let addressDetail: String
  let tel: String
  let managerTel: String
  let active: Bool
  let id: Int
  let name: String
  let url: String?
  let content: String
  let latitude: String
  let longitude: String
  let userId: Int
  let discount: Int
  let updatedAt: String
  let createdAt: String
}

struct StoreListResponse:Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  let storeList: [StoreList]
}

struct StoreList: Codable {
  let image, tel, managerTel: String
  let isDeliveryService: Bool
  let discount: String?
  let distance, longitude, address: String
  let latitude: String
  let active: Bool
  let createdAt, name: String
  let averageRate: Double
  let id: Int
  let isAreaVoucher: Bool
  let category: String?
  let logo1: String?
  let logo2: String?
}

struct StoreDetailReponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  let store: StoreDetail?
  
}
struct StoreDetail: Codable {
  let tel: String
  let averageRate: Double
  let longitude: String
  let id: Int
  let companyId: Int?
  let storeManager: StoreManager?
  let url: String?
  var addressDetail, latitude, distance: String
  let category: String?
  let createdAt, name: String
  let images: [String]
  let discount, managerTel: String?
  let address: String
  let isDeliveryService, isAreaVoucher: Bool
  let content: String
  let origin: String?
  let logo1: String?
  let logo2: String?
}

struct StoreManager: Codable {
  let id: Int
  let loginId: String
}

// 리뷰 리스트 
struct ReviewListResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  let reviewList: [ReviewList]
}

struct ReviewList: Codable {
  let id: Int
  let content: String
  let rate: Double
  let createdAt, userName: String
  let isUser: Bool
  let menus: String?
  let reviewPhotos: [ReviewPhoto]?
}

// MARK: - ReviewPhoto
struct ReviewPhoto: Codable {
  let id: Int
  let photoName: String
}

