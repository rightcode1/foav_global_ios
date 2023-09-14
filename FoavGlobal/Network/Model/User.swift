//
//  Users.swift
//  FOAV
//
//  Created by hoon Kim on 16/10/2019.
//  Copyright © 2019 hoon Kim. All rights reserved.


import Foundation

struct User: Codable {
  let tel:String?
  let email: String
  let id: Int
  let loginId, name, type: String
  let profile: String?
  let createdAt: String
  let serviceTime: Int
  let birth, gender: String
  let donation, stepsCount, totalStepsCount, totalServiceTime: Int
  let groupName, managerName: String?
  let point: Int?
  let carbon: Double?
  let monthCarbon: Double?
  let carbonPercent: Double?
  let staffNumber: String?
  let stateMessage: String?
  let companyId: Int?
  let code: String?
  let centerRole: String?
  let number1365: String?
  let image1365: String?
    let mainVersion: Bool?
    let mainLogo: String?
  let isFamily: Bool
    let charityVersion: Bool?
    let companySubId: Int?
}
