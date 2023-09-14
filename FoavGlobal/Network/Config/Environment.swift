//
//  Environment.swift
//  InsideROO
//
//  Created by jason on 02/02/2019.
//  Copyright © 2019 Dong Seok Lee. All rights reserved.
//

import Foundation
import UIKit

var storeId = -1
var updateSnsId: Int = 0
var updateCommentId: Int = 0
// 광고 아이디
var clickToAdvertisementId = 0
var deliveryServiceId: Int = 0
// Qr 코드
var QRCode = ""
//
var merchantUid = ""
var charityId = 0
var sendPhoneCodeType = "join"
var FcmDeviceToken = ""
var token = ""
var loginid = ""
var newsDetailId = 0
var noticeDetailId = 0
var partnershipId = 0
var serviceNewsId = 0
var latitude = ""
var longitude = ""
var serviceListYear = ""
var serviceListMonth = ""
var service = false

var order: Bool = false 

enum ServiceType {
  case start
  case end
}

enum SignupType {
  case normal
  case center
}


struct ApiEnvironment {
  //  http://13.125.237.115:8003 이전 주소
  static let baseUrl = "http://3.35.59.241"
  static let imageUrl = "https://d2twzv77g3c69u.cloudfront.net/fit-in"
  static let kakaoAppKey = Bundle.main.object(forInfoDictionaryKey: "KAKAO_APP_KEY") as! String
  static let kakaoRESTKey = Bundle.main.object(forInfoDictionaryKey: "KAKAO_REST_KEY") as! String
  //  static let serverGatewayStage = Bundle.main.object(forInfoDictionaryKey: "SERVER_GATEWAY_STAGE") as! String
}
