//
//  AdvertisementRequest.swift
//  FOAV
//
//  Created by hoon Kim on 30/10/2019.
//  Copyright © 2019 hoon Kim. All rights reserved.
//

import Foundation

struct AdvertisementRequest: Codable {
  let location: String?
  let latitude: String?
  let longitude: String?
  
  init(
    location: String? = nil,
    latitude: String? = nil,
    longitude: String? = nil
  ) {
    self.location = location
    self.latitude = latitude
    self.longitude = longitude
  }
}
struct AdvertisementCilckCountRequest: Codable {
  let advertisementId: Int
  enum Codingkeys: String,CodingKey {
    case advertisementId = "advertisementId"
  }
}
