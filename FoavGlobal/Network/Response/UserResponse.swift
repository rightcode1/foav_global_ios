//
//  UserResponse.swift
//  FOAV
//
//  Created by hoon Kim on 17/10/2019.
//  Copyright © 2019 hoon Kim. All rights reserved.
//

import Foundation

struct CompnaySubInfoResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  let list: [Company]
  
  struct Company: Codable {
    let id: Int
    let name: String
    let companyId: Int
  }

}
struct RegistDeviceResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
}

struct UpdateUserInfoResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
}

struct UserInfoResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  let user: User
  let newBadge: NewBadge
  let statistics: Statistics
  
  struct NewBadge: Codable {
    let noticeId: Int
    let newsId: Int
  }
  struct Statistics: Codable {
    let centerCount: Int
    let ManagerCount: Int
    let userCount: Int
    let serviceCount: Int
  }
}
struct UserWithdrawalResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
}

struct UserHistory: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  let currentStatus: CrrentStatus
  
  struct CrrentStatus: Codable {
    let zone: String
    let ServiceTime: Int
  }
}
struct ChangeUserEmailResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
}

struct servicePerformanceResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  let totalMilliseconds: Int
  let services: [Service]?
}
struct Service: Codable {
  let createdAt: String
  let zoneName: String
  let serviceTime: Int
  
}
struct UserCardCheckResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  let isCard: Bool
}

struct UserCardResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  let user: UserCard
}

struct UserCard: Codable {
  let id: Int
  let name, profile: String
  let serviceTime, donation: Int
}


struct RegistStepsCountRequest: Codable {
  let stepsCount: Int
  let date: String
}
// 리퀘스트 보낼 때 파라미터에 회워정보 수정 할 것들 넣고 보내기..
// 변수하나 만들어서 아이디 정보 집어넣기.
//

struct CompanyInfoResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  let data: CompanyInfo
}

struct CompanyInfo: Codable {
  let id: Int
  let diff, code, name: String
  let isShareBanner, idFoavBanner: Bool
  let createdAt, shareBanner, foavBanner, companyBanner: String
  let logo1, logo2, discountCard: String
}

struct WorkOfDayListResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  let list: [WorkOfDayList]
}

struct WorkOfDayList: Codable {
  let stepsCount: Int
  let createdAt: String
}
