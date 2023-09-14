//
//  RankDetailVC.swift
//  FOAV
//
//  Created by 이남기 on 2023/01/02.
//  Copyright © 2023 hoon Kim. All rights reserved.
//

import Foundation
import UIKit

class RankDetailVC: UIViewController {
  var rankList: [ChallengeUserRank] = []
  
  var rankDiff: String = "걸음"
  
  var myId: Int?
  var isWholeRank: Bool = false
  var numOfMonth: Int = 31
  let date = Date()
  let dateFormmat = DateFormatter()
  var companyId: Int?
  let calendar = Calendar(identifier: .gregorian)
  
  var isHome :Bool = false
  var dateStrings: (String,String)?
  
  //  25 137 196
  override func viewDidLoad() {
    super.viewDidLoad()
    
    }else{
      getList(diff: rankDiff)
    }
  }

// MARK: - UITableViewDataSource, UITableViewDelegate

