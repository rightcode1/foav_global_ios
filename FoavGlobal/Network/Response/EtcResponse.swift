//
//  EtcResponse.swift
//  BARO
//
//  Created by ldong on 2018. 1. 26..
//  Copyright © 2018년 weplanet. All rights reserved.
//

import Foundation

struct ErrorMessage: Decodable {
  var errorLog: [String]?
  var errorCode: String?
  //  var message: Message?
}
//
//struct Message: Codable {
//  var ko: String?
//}

struct BoolResponse: Codable {
  var data: Bool?
}

struct ResultResponse: Codable {
  var result: Bool
  var result_msg: String
}

struct DefaultResponse: Codable {
  var code: Int
  var result: Bool
  var resultMsg: String
}

struct ChallengeUserIdResponse: Codable {
  var code: Int
  var result: Bool
  var resultMsg: String
  let data: ChallengeUserId?
}

struct ChallengeUserId: Codable {
  let challengeUserId: Int
}

struct SavePointIdResponse: Codable {
  var code: Int
  var result: Bool
  var resultMsg: String
  let data: SavePointId?
}

struct SavePointId: Codable {
  let pointSaveId: Int
}

struct UserChallengeDetailResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  let data: UserChallengeDetail
}

struct UserChallengeDetail: Codable {
  let id: Int
  let userName, profile, content: String
  let like: Int
  let isConfirm: Bool
  let createdAt: String
  let challengeUserImages: [DetailImage]
}

