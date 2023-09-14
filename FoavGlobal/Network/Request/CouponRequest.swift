//
//  CouponRequest.swift
//  FOAV
//
//  Created by hoonKim on 2021/08/16.
//  Copyright © 2021 hoon Kim. All rights reserved.
//

import Foundation


struct CouponRegistRequest: Codable {
  let shopId: Int
  let point: Int
  let name: String
  let count: Int
  let endDate: String
}
