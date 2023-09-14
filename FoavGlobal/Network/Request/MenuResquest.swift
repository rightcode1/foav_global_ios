//
//  MenuResquest.swift
//  damda
//
//  Created by hoonKim on 2020/11/23.
//

import Foundation

struct MenuRegistResquest: Codable {
  let shopId: Int?
  let name: String
  let intro: String?
  let price: Int
  let sortCode: Int
}
