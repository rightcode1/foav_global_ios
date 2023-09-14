//
//  SignUpResponse.swift
//  FOAV
//
//  Created by hoon Kim on 16/10/2019.
//  Copyright © 2019 hoon Kim. All rights reserved.
//

import Foundation

struct LoginResponse: Codable {
    let code: Int
    let result: Bool
    let resultMsg: String
    let token: String!
}
struct KakaoCheckIdResponse: Codable {
    let code: Int
    let result: Bool
    let resultMsg: String
}

struct KakaoJoinResponse: Codable {
    let code: Int
    let result: Bool
    let resultMsg: String
}

struct SignupResponse: Codable {
    let code: Int
    let result: Bool
    let resultMsg: String
}

struct CheckIdResponse: Codable {
    let code: Int
    let result: Bool
    let resultMsg: String
}

struct ConfirmResponse: Codable {
    let code: Int
    let result: Bool
    let resultMsg: String
    let confirmHash: String?
    let effectiveTime: String?
}

struct FinighConfirmResponse: Codable {
    let code: Int
    let result: Bool
    let resultMsg: String
}

struct FindMyIdResponse: Codable {
    let code: Int
    let result: Bool
    let resultMsg: String
    let userId: String
}

struct ChangePasswordResponse: Codable {
    let code: Int
    let result: Bool
    let resultMsg: String
}

struct VisitResponse: Codable {
    let code: Int
    let result: Bool
    let resultMsg: String
}

struct PrivacyResponse: Codable {
    let code: Int
    let result: Bool
    let resultMsg: String
    let privacy: String
}
