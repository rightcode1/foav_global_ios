//
//  MyDonationListViewController.swift
//  FOAV
//
//  Created by hoon Kim on 13/01/2020.
//  Copyright © 2020 hoon Kim. All rights reserved.
//

import UIKit

class MyDonationListViewController: BaseViewController {
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var birthDayLabel: UILabel!
  @IBOutlet weak var companyNameTitleLabel: UILabel!
  @IBOutlet weak var companyNameLabel: UILabel!
  @IBOutlet weak var companyNumberTitleLabel: UILabel!
  @IBOutlet weak var companyNumberLabel: UILabel!
  
  @IBOutlet var myDonationTableView: UITableView!
  @IBOutlet var monthLb: UILabel!
  @IBOutlet var nothingView: UIView!
  
  let monthFormatter = DateFormatter()
  let yearFormatter = DateFormatter()
  let date = Date()
  var year = ""
  var month = ""
  
  var donationList = [CharityHistoryList]()
  let cellIdentifier = "DonationListCell"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    registerXib()
    myDonationTableView.delegate = self
    myDonationTableView.dataSource = self
    todayForm()
    //         Do any additional setup after loading the view.
    monthLb.text = "\(year)y\(month)m"
    (serviceList(todayDate: year + "-" + month))
    getUserInfo()
  }
    
  func todayForm() {
    monthFormatter.dateFormat = "MM"
    yearFormatter.dateFormat = "yyyy"
    month = monthFormatter.string(from: date)
    year = yearFormatter.string(from: date)
  }
  
  func getComapnyInfo(id: Int) {
    ApiService.request(router: UserApi.companyInfo(id: id) , success: { (response: ApiResponse<CompanyInfoResponse>) in
      guard let value = response.value else {
        return
      }
      if value.result {
        self.companyNameLabel.text = value.data.name
      } else if !value.result {
        self.doAlert(message: value.resultMsg)
      }
    }) { (error) in
      
    }
  }
  
  func getUserInfo() {
    ApiService.request(router: UserApi.userInfo, success: { (response: ApiResponse<UserInfoResponse>) in
      guard let value = response.value else {
        return
      }
      self.nameLabel.text = value.user.name
      self.birthDayLabel.text = value.user.birth
      
      self.companyNameTitleLabel.isHidden = value.user.companyId == nil
      self.companyNameLabel.isHidden = value.user.companyId == nil
      self.companyNameTitleLabel.isHidden = value.user.companyId == nil
      self.companyNumberLabel.isHidden = value.user.companyId == nil
      
      if value.user.companyId != nil {
        self.getComapnyInfo(id: value.user.companyId ?? 0)
        self.companyNumberLabel.text = value.user.staffNumber
      }
      
      
    }) { (error) in
      self.doAlert(message: "알수없는 오류입니다.\n잠시후 다시 시도해주세요.")
    }
  }
  
  func serviceList(todayDate: String) {
    ApiService.request(router: DonationApi.charityHistory(date: todayDate), success: { (response: ApiResponse<CharityHistoryListResponse>) in
      guard let value = response.value else {
        return
      }
      if value.result {
        self.donationList = value.list
        if self.donationList.count == 0 {
          self.view.bringSubviewToFront(self.nothingView)
        } else {
          self.view.bringSubviewToFront(self.myDonationTableView)
        }
        self.myDonationTableView.reloadData()
      }
    }) { (error) in
      self.doAlert(message: "알수없는 오류입니다.\n 다시 시도해주세요.")
    }
  }
  private func registerXib() {
    let nibName = UINib(nibName: "DonationListCell", bundle: nil)
    myDonationTableView.register(nibName, forCellReuseIdentifier: cellIdentifier)
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
    (serviceList(todayDate: year + "-" + "\(month)"))
    monthLb.text = "\(year)y\(month)m"
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
    (serviceList(todayDate: year + "-" + "\(month)"))
    monthLb.text = "\(year)y\(month)m"
  }
  
  
  @IBAction func backBtn(_ sender: Any) {
    self.navigationController!.popViewController(animated: true)
  }
  
}
extension MyDonationListViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return donationList.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = myDonationTableView.dequeueReusableCell(withIdentifier: "DonationListCell", for: indexPath) as! DonationListCell
    cell.companyLb.text = donationList[indexPath.row].company
    cell.dateLb.text = donationList[indexPath.row].createdAt
    let diff: String = donationList[indexPath.row].diff
    cell.payTypeLb.text = "\(diff)기부"
    cell.payLb.text = "\(donationList[indexPath.row].count.formattedProductPrice() ?? "")\(donationList[indexPath.row].diff)"
    cell.titleLb.text = donationList[indexPath.row].title
    
    cell.selectionStyle = .none
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 165
  }
  
}





