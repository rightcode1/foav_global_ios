//
//  DeliveryServiceResponse.swift
//  FOAV
//
//  Created by hoonKim on 2020/04/08.
//  Copyright © 2020 hoon Kim. All rights reserved.
//

import Foundation

struct DeliveryServiceDetailResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  let data: DataClass?
}

struct DataClass: Codable {
  let id: Int
  let keyword, introduction, storeIntroduction, deliveryServiceArea: String
  let deliveryCharge, takeoutCharge, freeDelivery, minimumPrice: Int
  let meetingKakaoPay, meetingCash, meetingAreaVoucher, takeout: Bool
  let meetingSumbank, meetingUlsanPay, meetingCard, zeroPay, active: Bool
  let detailImage: DetailImage?
  let menus: [Menu]
}

struct DetailImage: Codable {
  let id: Int
  let name: String
}

struct Menu: Codable {
  let id: Int
  let name: String
  let intro: String?
  let thumbnail: String?
  let isRepresentative: Bool
  var items: [MenuItem]
}

struct MenuItem: Codable {
  let id: Int?
  let name: String?
  let price: Int?
  let introduction: String?
  var menuCount: Int?
  let active: Bool?
  let image: DetailImage?
  let isRepresentative: Bool?
  
  init(
    id: Int? = nil,
    name: String? = nil,
    price: Int? = nil,
    introduction: String? = nil,
    menuCount: Int? = nil,
    active: Bool? = nil,
    image: DetailImage? = nil,
    isRepresentative: Bool? = nil
    
  ) {
    self.id = id
    self.name = name
    self.price = price
    self.introduction = introduction
    self.menuCount = menuCount
    self.active = active
    self.image = image
    self.isRepresentative = isRepresentative
  }
}


struct PaymentListResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  let list: [PaymentList]
}

struct PaymentList: Codable {
  let id: Int
  let totalPrice: Int
  let payMethod, createdAt: String
  let deliveryService: DeliveryService
}

struct DeliveryService: Codable {
  let id: Int
  let store: StoreName?
}

struct PaymentDetailResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  let data: PaymentDetail
}

// MARK: - DataClass
struct PaymentDetail: Codable {
  let id, totalPrice: Int
  let status, createdAt: String
  let isReviewMine: String
  let deliveryService: DeliveryService
  let items: [DetailItem]
}

// MARK: - Store
struct StoreName: Codable {
  let name: String
}


// MARK: - Item
struct DetailItem: Codable {
  let id: Int
  let name: String
  let price: Int
  let orderItem: OrderItem
}

// MARK: - OrderItem
struct OrderItem: Codable {
  let count, totalPrice: Int
}
