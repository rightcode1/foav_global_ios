//
//  SnsRequest.swift
//  FOAV
//
//  Created by hoonKim on 2020/08/26.
//  Copyright © 2020 hoon Kim. All rights reserved.
//

import Foundation

struct SnsRegistRequest: Codable {
  let title: String
  let content: String
  let youtube: String?
}

struct SnsListRequest: Codable {
  let search: String?
  let id: Int?
  let limit: Int?
}
