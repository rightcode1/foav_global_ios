//
//  ChallengeRankViewController.swift
//  FOAV
//
//  Created by hoonKim on 2021/03/25.
//  Copyright © 2021 hoon Kim. All rights reserved.
//

import UIKit

class ChallengeRankViewController: UIViewController {
  @IBOutlet var tableView: UITableView!
  
  @IBOutlet var monthView: UIView!
  
  @IBOutlet var selectView1: UIView!
  
  @IBOutlet var presentMonthButton: UIButton!{
    didSet{
      presentMonthButton.layer.cornerRadius = 5
    }
  }
  @IBOutlet var wholeButton: UIButton!{
    didSet{
      wholeButton.layer.cornerRadius = 5
    }
  }
  @IBOutlet var presentMonthLabel: UILabel!
  
  let date = Date()
  let dateFormmat = DateFormatter()
  let calendar = Calendar(identifier: .gregorian)
  
  var isTimeRank: Bool = false
  var isWholeRank: Bool = false
  
  var rankList: [ChallengeUserRank] = []
  
  var rankDiff: String = "걸음"
  
  var numOfMonth: Int = 31
  
  var myId: String?
  
  let selectColor = UIColor(red: 25/255, green: 137/255, blue: 196/255, alpha: 1.0)
  let notSelectColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1.0)
  //  25 137 196
  override func viewDidLoad() {
    super.viewDidLoad()
    dateFormmat.dateFormat = "MM"
    presentMonthLabel.text = dateFormmat.string(from: date) + "월"
    
    let rangeOfMonth = calendar.range(of: .calendar, in: .month, for: date)
    numOfMonth = (rangeOfMonth?.count ?? 30) + 1
    
    print("number of month : \(numOfMonth)")
    print("number of month : \(numOfMonth)")
    print("number of month : \(numOfMonth)")
    
    
    tableView.delegate = self
    tableView.dataSource = self
    

    getRankList(startDate: getDateString() + "01", endDate: getDateString() + "\(numOfMonth)")
  }
  
  func getList() {
    if isWholeRank {
      getRankList(startDate: nil, endDate: nil)
    } else {
      getRankList(startDate: getDateString() + "01", endDate: getDateString() + "\(numOfMonth)")
    }
  }
  
  func getDateString() -> String {
    dateFormmat.dateFormat = "yyyy-MM-"
    
    let dateString = dateFormmat.string(from: date)
    return dateString
  }
  
  func getRankList(startDate: String? = nil, endDate: String? = nil) {
    let param = ChallengeUserRankListRequest(startDate: startDate, endDate: endDate)
    ApiService.request(router: CarbonLivingApi.challengeUserRankList(param: param), success: { (response: ApiResponse<ChallengeUserRankListResponse>) in
      guard let value = response.value else {
        return
      }
      if value.result {
        if value.code >= 202 {
          self.doAlert(message: value.resultMsg)
        }else {
          self.rankList = value.list
          self.tableView.reloadData()
        }
      } else {
        if value.code >= 202 {
          self.doAlert(message: value.resultMsg)
        }
      }
    }) { (error) in
      self.doAlert(message: "알수없는 오류입니다. 잠시후 다시 시도해주세요.")
    }
  }
  
  @IBAction func tapGetWorkRankList(_ sender: UIButton) {
    
    getList()
    
  }
  
  @IBAction func tapGetTimeRankList(_ sender: UIButton) {
    
    getList()
  }
  
  @IBAction func tapPreenstMonth(_ sender: UIButton) {
    isWholeRank = false
    
    presentMonthButton.setTitleColor(.white, for: .normal)
    presentMonthButton.backgroundColor = selectColor
    
    wholeButton.setTitleColor(.lightGray, for: .normal)
    wholeButton.backgroundColor = notSelectColor
    
    getList()
  }
  
  @IBAction func tapWhole(_ sender: UIButton) {
    isWholeRank = true
    
    wholeButton.setTitleColor(.white, for: .normal)
    wholeButton.backgroundColor = selectColor
    
    presentMonthButton.setTitleColor(.lightGray, for: .normal)
    presentMonthButton.backgroundColor = notSelectColor
    
    getList()
  }
  
}
// MARK: - UITableViewDataSource, UITableViewDelegate
extension ChallengeRankViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return rankList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell")!
    let dict = rankList[indexPath.row]
    (cell.viewWithTag(1) as! UILabel).text = "\(dict.rank)"
    (cell.viewWithTag(2) as! UILabel).text = dict.loginId
    
    if self.myId == dict.loginId {
      (cell.viewWithTag(4)!).backgroundColor = #colorLiteral(red: 0.9181445241, green: 0.9614260793, blue: 1, alpha: 1)
    } else {
      (cell.viewWithTag(4)!).backgroundColor = .white
    }
    
    (cell.viewWithTag(3) as! UILabel).text = "\(dict.count)건"
    
    cell.selectionStyle = .none
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 40
  }
  
}
