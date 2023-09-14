//
//  CarbonPointHistoryListViewController.swift
//  FOAV
//
//  Created by hoonKim on 2021/02/18.
//  Copyright © 2021 hoon Kim. All rights reserved.
//

import UIKit

class CarbonPointHistoryListViewController: UIViewController {
  @IBOutlet var tableView: UITableView!
  @IBOutlet var monthLb: UILabel!
  
  let cellIdentifier: String = "CarbonPointHistoryCell"
  
  var pointHistoryList: [CarbonPointHistory] = []
  
  let monthFormatter = DateFormatter()
  let yearFormatter = DateFormatter()
  let date = Date()
  var year = ""
  var month = ""
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    todayForm()
    
    monthLb.text = "\(month)m"
    getPointHistory(date: year + "-" + month)
    registerXib()
  }
  
  func todayForm() {
    monthFormatter.dateFormat = "MM"
    yearFormatter.dateFormat = "yyyy"
    month = monthFormatter.string(from: date)
    year = yearFormatter.string(from: date)
  }
  
  private func registerXib() {
    let nibName = UINib(nibName: cellIdentifier, bundle: nil)
    tableView.register(nibName, forCellReuseIdentifier: cellIdentifier)
  }
  
  func getPointHistory(date: String) {
    ApiService.request(router: CarbonLivingApi.carbonPointHistoryList(date: date), success: { (response: ApiResponse<CarbonPointHistoryListResponse>) in
      guard let value = response.value else {
        return
      }
      if value.result {
        self.pointHistoryList = value.list
        self.tableView.reloadData()
      }
    }) { (error) in
      self.doAlert(message: "알수없는 오류입니다.\n잠시후 다시 시도해주세요.")
    }
  }
  
  @IBAction func previousMonth(_ sender: UIButton) {
    month = "\(Int(month)! - 1)"
    if Int(month)! == 0 {
      month = "\(12)"
      year = "\(Int(year)! - 1)"
    }
    if Int(month)! < 10 {
      month = "0" + month
    }
    getPointHistory(date: year + "-" + "\(month)")
    monthLb.text = "\(month)m"
  }
  @IBAction func nextMonthBtn(_ sender: UIButton) {
    month = "\(Int(month)! + 1)"
    if Int(month)! > 12 {
      month = "\(01)"
      year = "\(Int(year)! + 1)"
    }
    if Int(month)! < 10 || Int(month) == 1 {
      month = "0" + month
    }
    getPointHistory(date: year + "-" + "\(month)")
    monthLb.text = "\(month)m"
  }
}

extension CarbonPointHistoryListViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return pointHistoryList.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CarbonPointHistoryCell
    let dict = pointHistoryList[indexPath.row]
    cell.initWithCarbonPointHistory(dict)
    cell.shadowView.layer.cornerRadius = 8
    cell.shadowView.layer.shadowColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    cell.shadowView.layer.shadowOffset = CGSize(width: 0, height: 1)
    cell.shadowView.layer.shadowOpacity = 1
    cell.shadowView.layer.shadowRadius = 2
    cell.selectionStyle = .none
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }
  
  
}
