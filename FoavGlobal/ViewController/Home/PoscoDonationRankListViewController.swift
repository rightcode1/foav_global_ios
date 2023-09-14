//
//  PoscoDonationRankListViewController.swift
//  FOAV
//
//  Created by hoonKim on 2021/02/18.
//  Copyright © 2021 hoon Kim. All rights reserved.
//

import UIKit

class PoscoDonationRankListViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
  
  @IBOutlet var monthView: UIView!
  
  @IBOutlet var selectView1: UIView!
  @IBOutlet var selectView2: UIView!
  
  @IBOutlet var diffLabel: UILabel!
  
  @IBOutlet var weekButton: UIButton!{
    didSet{
      weekButton.layer.cornerRadius = 5
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
    
    var homeRankList: [CharityRankList] = []
  
  let date = Date()
  let dateFormmat = DateFormatter()
  let calendar = Calendar(identifier: .gregorian)
  
  var isTimeRank: Bool = false
  var isWholeRank: Bool = false
  
  var rankDiff: String = "걸음"
  
  var numOfMonth: Int = 31
  
  let selectColor = UIColor(red: 25/255, green: 137/255, blue: 196/255, alpha: 1.0)
  let notSelectColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1.0)
  
  var companyId: Int?
  var myId: Int?
  var dateStrings: (String,String)?
  //  25 137 196
  override func viewDidLoad() {
    super.viewDidLoad()
      dateFormmat.dateFormat = "MM"
      
      let rangeOfMonth = calendar.range(of: .calendar, in: .month, for: date)
      numOfMonth = (rangeOfMonth?.count ?? 30) + 1
      
      tableView.delegate = self
      tableView.dataSource = self
      getList(diff: rankDiff, dateStrings: dateStrings)
  }
  
  func getMondayAndNextMonday(myDate: Date) -> (String, String) {
    let dateFormmat = DateFormatter()
    let dayOffset = DateComponents(day: 7)
    
    let cal = Calendar.current
    
    var comps = cal.dateComponents([.weekOfYear, .yearForWeekOfYear], from: myDate)
    
    comps.weekday = 1 // Monday
    
    let mondayInWeek = cal.date(from: comps)! // Date
    
    dateFormmat.dateFormat = "yyyy-MM-dd 00:00"
    
    let mondayDateString = dateFormmat.string(from: mondayInWeek)
    
    let plusDateString = dateFormmat.string(from: cal.date(byAdding: dayOffset, to: mondayInWeek)!)
    
    return (mondayDateString, plusDateString)
  }

  func getStartOfMonthAndEndOfMonthDate(myDate: Date) -> (String, String) {
    let dateFormmat = DateFormatter()
    let calendar = Calendar(identifier: .gregorian)
    let components = calendar.dateComponents([.year, .month], from: myDate)

    let startOfMonthDate = calendar.date(from: components)!
    
    var endComponents = DateComponents()
    endComponents.month = 1
    endComponents.second = -1
    
    let endOfMonthDate = calendar.date(byAdding: endComponents, to: startOfMonthDate)!
    
    dateFormmat.dateFormat = "yyyy-MM-dd 00:00"
    
    let startString = dateFormmat.string(from: startOfMonthDate)
    let endString = dateFormmat.string(from: endOfMonthDate)
    
    return (startString, endString)
  }
    func getList(diff: String, dateStrings: (String, String)? = nil) {
      if isWholeRank {
        getHomeRankList(rankDiff: diff, startDate: dateStrings?.0, endDate: dateStrings?.1, companyId: companyId)
      } else {
        getHomeRankList(rankDiff: rankDiff, startDate: dateStrings?.0, endDate: dateStrings?.1, companyId: companyId)
      }
    }
    
    func getHomeRankList(rankDiff: String, startDate: String? = nil, endDate: String? = nil, companyId: Int? = nil) {
      myView.isHidden = true
      let param = CharityRankListRequest(diff: rankDiff, startDate: startDate, endDate: endDate, companyId: companyId)
      ApiService.request(router: DonationApi.charityRank(param: param), success: { (response: ApiResponse<CharityRankResponse>) in
        guard let value = response.value else {
          return
        }
        if value.result {
          if value.code >= 202 {
            self.doAlert(message: value.resultMsg)
          }else {
            self.homeRankList = value.list
            for i in 0 ..< value.list.count{
              if self.myId == value.list[i].userId {
                self.myView.isHidden = false
                self.myLevelLabel.text = "\(value.list[i].rank)"
                self.myIdLabel.text = value.list[i].user.loginId
                self.myWalkCountLabel.text = "\(value.list[i].sumCount)걸음"
              }
            }
          }
            self.tableView.layoutTableHeaderView()
          self.tableView.reloadData()
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
    diffLabel.text = "걸음총합"
    let dateStrings = getMondayAndNextMonday(myDate: date)
    self.dateStrings = dateStrings
      
      getList(diff: rankDiff, dateStrings: dateStrings)
  }
  
  @IBAction func tapGetTimeRankList(_ sender: UIButton) {
    selectView1.isHidden = true
    selectView2.isHidden = false
    rankDiff = "시간"
    diffLabel.text = "시간총합"
    let dateStrings = getMondayAndNextMonday(myDate: date)
    self.dateStrings = dateStrings
      
      getList(diff: rankDiff, dateStrings: dateStrings)
  }
  
  @IBAction func tapPreenstMonth(_ sender: UIButton) { // tapPresentWeek
    isWholeRank = false
    let dateStrings = getMondayAndNextMonday(myDate: date)
    weekButton.setTitleColor(.white, for: .normal)
    weekButton.backgroundColor = selectColor
    
    wholeButton.setTitleColor(.lightGray, for: .normal)
    wholeButton.backgroundColor = notSelectColor
    self.dateStrings = dateStrings
      
      getList(diff: rankDiff, dateStrings: dateStrings)
  }
  
  @IBAction func tapWhole(_ sender: UIButton) {
    isWholeRank = true
    
    let dateStrings = getStartOfMonthAndEndOfMonthDate(myDate: date)
    wholeButton.setTitleColor(.white, for: .normal)
    wholeButton.backgroundColor = selectColor
    
    weekButton.setTitleColor(.lightGray, for: .normal)
    weekButton.backgroundColor = notSelectColor
    self.dateStrings = dateStrings
      
      getList(diff: rankDiff, dateStrings: dateStrings)
    
  }
  
}
extension PoscoDonationRankListViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return homeRankList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell")!
    let dict = homeRankList[indexPath.row]
    (cell.viewWithTag(1) as! UILabel).text = "\(dict.rank)"
    (cell.viewWithTag(2) as! UILabel).text = dict.user.loginId
    
    if self.myId == dict.userId {
      (cell.viewWithTag(4)!).backgroundColor = #colorLiteral(red: 0.9181445241, green: 0.9614260793, blue: 1, alpha: 1)
    } else {
      (cell.viewWithTag(4)!).backgroundColor = .white
    }
    
    (cell.viewWithTag(3) as! UILabel).text = "\(dict.sumCount)걸음"
    
    cell.selectionStyle = .none
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 40
  }
  
}

