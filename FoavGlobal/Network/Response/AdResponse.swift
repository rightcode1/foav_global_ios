//
//  AdResponse.swift
//  FOAV
//
//  Created by hoonKim on 2021/08/18.
//  Copyright © 2021 hoon Kim. All rights reserved.
//

import Foundation

// MARK: - SnsV2CommentListResponse
struct AdListResponse: Codable {
    let code: Int
    let result: Bool
    let resultMsg: String
    let list: [AdList]
}

// MARK: - List
struct AdList: Codable {
    let id: Int
    let address, type: String
    let price: Int
    let startDate, endDate: String
    let sns: SnsV2List?
    let shop: ShopList?
}


