//
//  CompanyIntroductionResponse.swift
//  FOAV
//
//  Created by hoonKim on 2021/01/25.
//  Copyright © 2021 hoon Kim. All rights reserved.
//

import Foundation
// 참여기업소개

struct CompanyIntroductionListResponse: Codable {
    let code: Int
    let result: Bool
    let resultMsg: String
    let list: [CompanyIntroductionList]
}

struct CompanyIntroductionList: Codable {
    let id: Int
    let title: String
    let thumbnail: String?
    let createdAt: String
}

