//
//  CarbonLivingResponse.swift
//  FOAV
//
//  Created by hoonKim on 2021/02/02.
//  Copyright © 2021 hoon Kim. All rights reserved.
//

import Foundation

struct CarbonLivingListResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  let list: [CarbonLivingList]
}

struct CarbonLivingList: Codable {
  let id: Int
  let title: String
  let content: String?
  let createdAt: String?
  let thumbnail: String?
}

struct CarbonLivingDetailResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  let data: CarbonLivingDetail
}

struct CarbonLivingDetail: Codable {
  let id: Int
  let title: String
  let content: String
  let createdAt: String 
  let link: String?
  let thumbnail: String?
  let images: [String]?
}

struct CarbonCompanyListResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  let list: [CarbonCompany]
}

struct CarbonCompany: Codable {
  let id: Int
  let title: String
  let thumbnail: String?
  let createdAt: String
}

struct CarbonCompanyDetailResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  let data: CarbonCompanyDetail
}

struct CarbonCompanyDetail: Codable {
  let id: Int
  let title, content, createdAt: String
  let youtube, link, thumbnail: String?
  let images: [String]?
}

struct ChallengeListResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  let list: [ChallengeList]
}

struct ChallengeList: Codable {
  let id: Int
  let title, startDate, endDate: String
  let thumbnail: String?
  let category: String?
  let join: Int
  let status: String
  let active: Bool
  let challengeUserCommentCount: Int 
}


struct ChallengeDetailResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  let data: ChallengeDetail
}

struct  ChallengeDetail: Codable {
  let id: Int
  let title, startDate, endDate: String
  let thumbnail: String?
  let youtube: String?
  let link: String?
  let banner: String?
  let bannerDetail: String?
  let url: String?
  let mission, way, people, condition: String
  let note, status: String
  let join, dDay: Int
}

struct ChallengeUserListResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  let list: ChallengeUserListRows
}

struct ChallengeUserList_OnlyListResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  let list: [ChallengeUserList]
}

struct ChallengeUserListRows: Codable {
  let count: Int
  let rows: [ChallengeUserList]
}

struct ChallengeUserList: Codable {
  let id: Int
  let name: String?
  let userName, content: String
  let profile: String?
  var like: Int
  let isConfirm: Bool
  let createdAt: String
  let challengeUserImages: [Image]
  var isLike: Bool
  let commentCount: Int
}

struct Image: Codable {
  let id: Int
  let name: String
}


struct CarbonInfoResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  let data: CarbonInfo
}

struct CarbonInfo: Codable {
  let id: Int
  let pine, totalCarbon: Double
}

struct RegistCarbonPointResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  let data: RegistCarbonPointInfo?
}

struct RegistCarbonPointInfo: Codable {
  let id: Int
  let diff: String
  let point: Int
}

struct CarbonPointHistoryListResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  let list: [CarbonPointHistory]
}

struct CarbonPointHistory: Codable {
  let id: Int
  let diff: String
  let point: Int
  let content: String
  let carbonReduction: Double?
  let userName: String
  let storeName, carbonSaveStoreName, qrName: String?
  let createdAt: String
}

struct ChallengeUserRankListResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  let list: [ChallengeUserRank]
}

struct ChallengeUserRank: Codable {
  let rank: Int
  let userName: String
  let loginId: String
  let count: Int
}

struct ChallengeUserDetailResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  let data: ChallengeUserDetail
}

struct ChallengeUserDetail: Codable {
  let id: Int
  let name: String?
  let userName, profile, content: String
  let like: Int
  let createdAt: String
  let challengeUserImages: [Image]
  let commentCount: Int
  let isLike: Bool
}

struct ChallengeUserCommentListResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  let list: [ChallengeUserCommentList]
}

struct ChallengeUserCommentList: Codable {
  let id, userId: Int
  let content: String
  let wishCount: Int
  let isWish: Bool
  let createdAt: String
  let user: CommentUser
}

struct CommentUser: Codable {
  let loginId: String
}

struct CarbonSaveStoreListResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  let list: [CarbonSaveStoreList]
}

struct CarbonSaveStoreList: Codable {
  let id: Int
  let name, qrName: String
  let point: Int
  let carbonReduction: Double
  let distance: Double
  let active: Bool
  let address: String
  let addressDetail: String?
  let latitude, longitude, createdAt: String
  let images: [Image]
}
