//
//  ChallengeRequest.swift
//  FOAV
//
//  Created by hoon Kim on 2021/12/20.
//  Copyright © 2021 hoon Kim. All rights reserved.
//

import Foundation

struct ChallengeListRequest: Codable {
  let companyId: Int?
  let category: String?
  let diff: String?
  
  init(
    companyId: Int? = nil,
    category: String? = nil,
    diff: String? = nil
  ) {
    self.companyId = companyId
    self.category = category
    self.diff = diff
  }
}
