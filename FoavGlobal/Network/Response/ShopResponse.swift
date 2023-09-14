//
//  ShopResponse.swift
//  FOAV
//
//  Created by hoonKim on 2021/08/15.
//  Copyright © 2021 hoon Kim. All rights reserved.
//

import Foundation

// MARK: - ShopListResponse
struct ShopListResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  let list: [ShopList]
}

// MARK: - List
struct ShopList: Codable {
  let thumbnail: String
  let name, longitude: String
  let id: Int
  let latitude, intro: String
  let category: String?
  let distance: Double
  let address: String
  let reviewCount: Int
  let averageRate: Double
  let isCoupon: Bool
  let isPackage: Bool?
  let isTumbler: Bool?
  let isCurrency: Bool?
}

// MARK: - ShopDetailResponse
struct ShopDetailResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  let data: ShopDetailData
}

// MARK: - ShopDetailData
struct ShopDetailData: Codable {
  let id: Int
  let latitude, longitude, category: String
  let coupons: [ShopCoupon]
  let name, time, tel: String
  let reviewCount: Int
  let averageRate: Double
  let images: [Image]
  let address, addressDetail, intro: String
  let homepage: String?
  let review: ShopReview?
  let menus: [ShopMenu]
  let thumbnail: String
  let isPackage: Bool
  let isTumbler: Bool
  let isCurrency: Bool
}

// MARK: - Coupon
struct ShopCoupon: Codable {
  let id, point: Int
  let name: String
  let endDate: String
  let isDownload: Bool
  let isUsed: Bool
}

// MARK: - ShopMenu
struct ShopMenu: Codable {
  let id: Int
  let name: String
  let intro: String?
  let price: Int
  let thumbnail: String?
}

struct ShopReviewListResponse: Codable{
  let code: Int
  let result: Bool
  let resultMsg: String
  let list: [ShopReview]
}

// MARK: - ShopReview
struct ShopReview: Codable {
  let id, userId: Int
  let content: String
  let rate: Double
  let comment: String?
  let commentUpdateAt: String?
  let createdAt: String
  let images: [Image]
  let user: UserInfo
}

// MARK: - UserInfo
struct UserInfo: Codable {
  let id: Int
  let profile:String?
  let name: String
  let loginId: String?
}

struct ShopRegistResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  let data: ShopRegistIdData?
}

struct ShopRegistIdData: Codable {
  let shopId: Int
}

struct ShopReviewRegistResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  let data: ShopReviewRegistIdData?
}

struct ShopReviewRegistIdData: Codable {
  let shopReviewId: Int
}
