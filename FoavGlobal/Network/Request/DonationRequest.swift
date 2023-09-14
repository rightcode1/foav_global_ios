//
//  DonationRequest.swift
//  FOAV
//
//  Created by hoon Kim on 12/01/2020.
//  Copyright © 2020 hoon Kim. All rights reserved.
//

import Foundation

struct CharityListRequest: Codable {
  let diff: String?
  let category: String?
  
  init(
    diff: String? = nil,
    category: String? = nil
  ) {
    self.diff = diff
    self.category = category
  }
}

struct CharityDetailRequest: Codable {
  let charityId: Int
}

struct DonationListRequest: Codable {
  let date: String
  enum CodingKeys: String, CodingKey {
    case date = "date"
  }
}

struct PaymentDonationRequest: Codable {
  let charityId, price: Int
  let payMethod: String
  
  enum CodingKeys: String, CodingKey {
    case charityId = "charityId"
    case price, payMethod
  }
}
struct PayCheckRequest: Codable {
  let implUid, merchantUid: String
}

struct CharityRankListRequest: Codable {
  let diff: String
  let startDate: String?
  let endDate: String?
  let companyId: Int?
}
