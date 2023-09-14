//
//  CarbonLivingRequest.swift
//  FOAV
//
//  Created by hoonKim on 2021/02/15.
//  Copyright © 2021 hoon Kim. All rights reserved.
//

import Foundation

struct RegistCarbonPointRequest: Codable {
  let carbonSaveStoreId: Int?
  let storeId: Int?
}

struct ChallengeUserListRequest: Codable {
  let page: Int?
  let limit: Int?
  let challengeId: Int
}

struct ChallengeUserRankListRequest: Codable {
  let startDate: String?
  let endDate: String?
}
