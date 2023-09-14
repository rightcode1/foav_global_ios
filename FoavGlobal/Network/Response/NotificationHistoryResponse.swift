//
//  NotificationHistoryResponse.swift
//  FOAV
//
//  Created by hoon Kim on 2021/11/29.
//  Copyright © 2021 hoon Kim. All rights reserved.
//

import Foundation

// MARK: - NotificationHistoryListResponse
struct NotificationHistoryListResponse: Codable {
    let code: Int
    let result: Bool
    let resultMsg: String
    let list: [NotificationHistoryListData]
}

// MARK: - NotificationHistoryListData
struct NotificationHistoryListData: Codable {
    let id: Int
    let message, createdAt: String
}
