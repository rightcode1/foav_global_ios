//
//  HomeResponse.swift
//  FOAV
//
//  Created by hoon Kim on 30/10/2019.
//  Copyright © 2019 hoon Kim. All rights reserved.
//

import Foundation

struct YoutubeCodeResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  let mainVideo: MainVideo
  
  struct MainVideo: Codable {
    let id: Int
    let code: String
  }
}
struct FoavNewsResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  let newsList: [FoavNews]
  
  struct FoavNews: Codable {
    let title: String
    let id: Int
    let sortCode: Int
    let createdAt: String
    let content: String
    let thumbnail: String?
    let thumbnailName: String?
  }
}

struct AdvertisementResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  let advertisements: [AdVertisements]
}

struct AdVertisements: Codable {
  let id: Int
  let url: String?
  let image: String?
  let thumbnail: String
  let thumbnailName: String?
  let viewCount: Int
  let updatedAt: String
}

struct AdvertisementClinkCountResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
}
struct HomeDataResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg, serviceTime, donation: String
}

struct HomePopupResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  let advertisements: [PopupData]?
}

struct PopupData: Codable {
  let id: Int
  let image: String?
  let url: String?
  let thumbnail: String? 
}
