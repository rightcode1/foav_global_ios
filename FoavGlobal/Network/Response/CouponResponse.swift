//
//  CouponResponse.swift
//  FOAV
//
//  Created by hoonKim on 2021/08/16.
//  Copyright © 2021 hoon Kim. All rights reserved.
//

import Foundation


struct MyCouponListResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  let list: [MyCouponList]
}


struct MyCouponList: Codable {
  let id: Int
  let point, useCount, count: Int
  let name, startDate, endDate: String
  let isUsed: Bool
}


struct UserCouponListResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  let list: [UserCouponList]
}


struct UserCouponList: Codable {
  let id, point: Int
  let name: String
  let storeName: String?
  let endDate: String
  let isDownload: Bool
  let isUsed: Bool
}
