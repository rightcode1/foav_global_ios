//
//  DonationRankViewController.swift
//  FOAV
//
//  Created by hoonKim on 2020/10/21.
//  Copyright © 2020 hoon Kim. All rights reserved.
//

import UIKit

class DonationRankViewController: UIViewController {
  @IBOutlet var tableView: UITableView!
  
  @IBOutlet var monthView: UIView!
  
  @IBOutlet var selectView1: UIView!
  @IBOutlet var selectView2: UIView!
  
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
  
  @IBOutlet var myLevelLabel: UILabel!
  @IBOutlet var myIdLabel: UILabel!
  @IBOutlet var myWalkCountLabel: UILabel!
  @IBOutlet var myView: UIView!
  
  let date = Date()
  let dateFormmat = DateFormatter()
  let calendar = Calendar(identifier: .gregorian)
  
  var isTimeRank: Bool = false
  var isWholeRank: Bool = false
  
  var rankList: [CharityRankList] = []
  
  var rankDiff: String = "걸음"
  
  var numOfMonth: Int = 31
  
  var myId: Int?
  
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
    

    getRankList(rankDiff: rankDiff, startDate: getDateString() + "01", endDate: getDateString() + "\(numOfMonth)")
  }
  
  func getList(diff: String) {
    if isWholeRank {
      getRankList(rankDiff: diff, startDate: nil, endDate: nil)
    } else {
      getRankList(rankDiff: diff, startDate: getDateString() + "01", endDate: getDateString() + "\(numOfMonth)")
    }
  }
  
  func getDateString() -> String {
    dateFormmat.dateFormat = "yyyy-MM-"
    
    let dateString = dateFormmat.string(from: date)
    return dateString
  }
  
  func getRankList(rankDiff: String, startDate: String? = nil, endDate: String? = nil, companyId: Int? = nil) {
    myView.isHidden = true
    let param = CharityRankListRequest(diff: rankDiff, startDate: startDate, endDate: endDate, companyId: companyId)
    ApiService.request(router: DonationApi.charityRank(param: param), success: { (response: ApiResponse<CharityRankResponse>) in
      guard let value = response.value else {
        return
      }
      if value.result {
        if value.code >= 202 {
          self.doAlert(message: value.resultMsg)
        } else {
          self.rankList = value.list
          for i in 0 ..< value.list.count{
            if self.myId == value.list[i].userId {
              self.myView.isHidden = false
            }
          }
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
    selectView1.isHidden = false
    selectView2.isHidden = true
    
    rankDiff = "걸음"
    getList(diff: rankDiff)
    
  }
  
  @IBAction func tapGetTimeRankList(_ sender: UIButton) {
    selectView1.isHidden = true
    selectView2.isHidden = false
    
    rankDiff = "시간"
    getList(diff: rankDiff)
  }
  
  @IBAction func tapPreenstMonth(_ sender: UIButton) {
    isWholeRank = false
    monthView.isHidden = false
    
    if let header = tableView.tableHeaderView {
      let newSize = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
      header.frame.size.height = newSize.height
    }
    
    presentMonthButton.setTitleColor(.white, for: .normal)
    presentMonthButton.backgroundColor = selectColor
    
    wholeButton.setTitleColor(.lightGray, for: .normal)
    wholeButton.backgroundColor = notSelectColor
    
    getList(diff: rankDiff)
  }
  
  @IBAction func tapWhole(_ sender: UIButton) {
    isWholeRank = true
    monthView.isHidden = true
    
    wholeButton.setTitleColor(.white, for: .normal)
    wholeButton.backgroundColor = selectColor
    
    if let header = tableView.tableHeaderView {
      let newSize = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
      header.frame.size.height = newSize.height
    }
    
    presentMonthButton.setTitleColor(.lightGray, for: .normal)
    presentMonthButton.backgroundColor = notSelectColor
    
    getList(diff: rankDiff)
  }
  
}
// MARK: - UITableViewDataSource, UITableViewDelegate
extension DonationRankViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return rankList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell")!
    let dict = rankList[indexPath.row]
    (cell.viewWithTag(1) as! UILabel).text = "\(dict.rank)"
    (cell.viewWithTag(2) as! UILabel).text = dict.user.loginId
    
    (cell.viewWithTag(3) as! UILabel).text = "\(dict.sumCount) \(dict.diff)"
    
    if self.myId == dict.userId {
      (cell.viewWithTag(5)!).backgroundColor = #colorLiteral(red: 0.9201955199, green: 0.9604334235, blue: 0.998159349, alpha: 1)
      myLevelLabel.text = "\(dict.rank)"
      myIdLabel.text = dict.user.loginId ?? ""
      myWalkCountLabel.text = "\(dict.sumCount) \(dict.diff)"
    } else {
      (cell.viewWithTag(5)!).backgroundColor = .white
    }
    
    cell.selectionStyle = .none
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 40
  }
  
}
