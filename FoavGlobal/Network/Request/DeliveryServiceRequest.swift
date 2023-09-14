//
//  DeliveryServiceRequest.swift
//  FOAV
//
//  Created by hoonKim on 2020/04/09.
//  Copyright © 2020 hoon Kim. All rights reserved.
//

import Foundation

struct OrderRegistRequest: Codable {
    let address: String
    let addressDetail: String
    let latitude: String
    let longitude: String
    let tel: String
    let request: String?
    let deliveryRequest: String?
    let payMethod: String
    let items: [OrderMenus]
}

struct OrderMenus: Codable {
    let itemId: Int
    let count: Int
}
