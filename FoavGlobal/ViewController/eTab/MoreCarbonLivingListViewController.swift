//
//  MoreCarbonLivingListViewController.swift
//  FOAV
//
//  Created by hoon Kim on 2021/12/02.
//  Copyright © 2021 hoon Kim. All rights reserved.
//

import UIKit

class MoreCarbonLivingListViewController: UIViewController {
  
  @IBOutlet var carbonLivingListTableView: UITableView!
  
  var carbonLivingList: [CarbonLivingList] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    carbonLivingListTableView.delegate = self
    carbonLivingListTableView.dataSource = self
    
    
    carbonLivingListTableView.reloadData()
  }
  
  
  
}
extension MoreCarbonLivingListViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return carbonLivingList.count
  }
   
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CarbonLivingListCell
    let dict = carbonLivingList[indexPath.row]
    
    cell.initWithCarbonLivingList(dict)
    cell.selectionStyle = .none
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
    return 125
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let dict = carbonLivingList[indexPath.row]
    let vc = UIStoryboard(name: "eTab", bundle: nil).instantiateViewController(withIdentifier: "carbonLivingDetail") as! CarbonLivingDetailViewController
    vc.id = dict.id
    self.navigationController?.pushViewController(vc, animated: true)
  }
}
