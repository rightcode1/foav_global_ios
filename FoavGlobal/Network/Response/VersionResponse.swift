//
//  VersionResponse.swift
//  FOAV
//
//  Created by hoon Kim on 20/11/2019.
//  Copyright © 2019 hoon Kim. All rights reserved.
//

import Foundation

struct CheckVersioinResponse: Codable {
    let code: Int
    let result: Bool
    let resultMsg: String
    let versions: Version
    
    struct Version: Codable {
        let iosGlobal: Int
        let androidGlobal: Int
    }
}
