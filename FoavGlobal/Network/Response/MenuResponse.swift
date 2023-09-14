//
//  MenuResponse.swift
//  damda
//
//  Created by hoonKim on 2020/11/23.
//

import Foundation

struct MenuListResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  let list: [MenuList]
}

struct MenuList: Codable {
  let id: Int
  let name: String
  let sortCode: Int
}
struct MenuDetailResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  let data: MenuDetail
}

struct MenuDetail: Codable {
  let id: Int
  let name: String
  let intro: String?
  let thumbnail: String?
  let price: Int
  let sortCode: Int
}

struct MenuRegistResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  let data: Data?
  
  struct Data: Codable {
    let shopMenuId: Int
  }
}

