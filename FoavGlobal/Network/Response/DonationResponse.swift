//
//  DonationResponse.swift
//  FOAV
//
//  Created by hoon Kim on 12/01/2020.
//  Copyright © 2020 hoon Kim. All rights reserved.
//

import Foundation


struct CharityListResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  let charityList: [CharityList]
}

struct CharityList: Codable {
  let diff: String
  let goal: Int
  let companyCode: String?
  let createdAt, startDate, company: String
  let thumbnail: String?
  let title, endDate: String
  let current, id,totalUserCount: Int
  let active: Bool
}

struct CharityListV2Response: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  let charityList: [CharityListV2]?
}

struct CharityListV2: Codable {
  let id: Int
  let companyCode: String?
  let company, title, startDate, endDate: String
  let goal, current: Int
  let diff: String
  let thumbnail: String?
  let active: Bool
  let createdAt: String
}

struct CharityDetailResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  let charity: Charity
  
  struct Charity: Codable {
    let id: Int
    let companyCode: String?
    let company, title, startDate, endDate: String
    let goalPrice, goal, current: Int
    let diff: String
    let link: String?
    let totalUserCount: Int?
    let thumbnail, image: String?
    let code: String?
    let dDay, createdAt: String
    let active: Bool
      let english: String?
  }
}

struct DonationListResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  let donationList: [DonationList]
}

struct DonationList: Codable {
  let company, title: String?
  let payMethod, createdAt: String
  let price: Int
}

struct PaymentDonationResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  let merchantUid: String
}

struct CharityHistoryListResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  let list: [CharityHistoryList]
}

struct CharityHistoryList: Codable {
  let id, charityId, count: Int
  let diff, title, company, createdAt: String
}

struct DonationResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  let data: Data?
  
  struct Data: Codable {
    let id: Int
    let count: Int
    let diff: String
    let createdAt: String
  }
}

struct CharityRankResponse: Codable {
    let code: Int
    let result: Bool
    let resultMsg: String
    let list: [CharityRankList]
}

struct CharityRankList: Codable {
    let sumCount: String
    let diff: String
    let userId: Int
    let user: CharityUserData
    let rank: Int
}


struct CharityUserData: Codable {
    let tel, name, loginId: String?
  let stateMessage: String?
}
