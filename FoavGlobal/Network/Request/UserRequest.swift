//
//  UserRequest.swift
//  FOAV
//
//  Created by hoon Kim on 17/10/2019.
//  Copyright © 2019 hoon Kim. All rights reserved.
//

import Foundation

struct UpdateUserInfoRequest: Codable {
  let birth: String?
  let email: String?
  let code: String?
  let staffNumber: String?
  let stateMessage: String?
  let number1365: String?
  let isFamily: Bool?
    let companySubId: Int?
  init(
    birth: String? = nil,
    email: String? = nil,
    code: String? = nil,
    staffNumber: String? = nil,
    stateMessage: String? = nil,
    number1365: String? = nil,
    companySubId: Int? = nil,
    isFamily: Bool? = nil
  ) {
    self.birth = birth
    self.email = email
    self.code = code
    self.staffNumber = staffNumber
    self.stateMessage = stateMessage
    self.number1365 = number1365
      self.companySubId = companySubId
    self.isFamily = isFamily
  }
}

struct ChangeUserEmailRequest: Codable {
  let email: String
}

struct RegistDeviceRequest: Codable {
  let uuid: String
  
  enum CodingKeys: String, CodingKey {
    case uuid = "deviceKey"
  }
}

