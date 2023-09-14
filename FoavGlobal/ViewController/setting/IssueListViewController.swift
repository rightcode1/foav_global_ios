//
//  IssueListViewController.swift
//  FOAV
//
//  Created by hoon Kim on 31/12/2019.
//  Copyright © 2019 hoon Kim. All rights reserved.
//

import UIKit

class IssueListViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var newInfoListView: UITableView!{
        didSet{
            newInfoListView.delegate = self
            newInfoListView.dataSource = self
        }
    }
    
    var serviceNews = [RowsNews]()
    
    let cellIdentifier = "newInfoCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        registerXib()
        getNewsListInfo()
        // Do any additional setup after loading the view.
    }
    private func registerXib() {
        let nibName = UINib(nibName: "newInfoCell", bundle: nil)
        newInfoListView.register(nibName, forCellReuseIdentifier: cellIdentifier)
    }

    func getNewsListInfo() {
        ApiService.request(router: SettingApi.serviceMainNewsList, success: { (response: ApiResponse<ServiceMainNewsListResponse>) in
            guard let value = response.value else {
                return
            }
            if value.result {
                self.serviceNews = value.serviceNewsList.rows 
                self.newInfoListView.reloadData()
                print("_____\(self.serviceNews)")
            }
            
        }) { (error) in
            self.doAlert(message: "알수없는 오류입니다.\n잠시후 다시 시도해주세요.")
        }
        
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }

}
extension IssueListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serviceNews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = newInfoListView.dequeueReusableCell(withIdentifier: "newInfoCell", for: indexPath) as! newInfoTableViewCell
        cell.newInfoLabel.text = serviceNews[indexPath.row].title
        cell.dateLabel.text = String(serviceNews[indexPath.row].createdAt.unicodeScalars.prefix(10))
        cell.separatorInset = UIEdgeInsets.zero
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "issueVC") as! IssueDetailViewController
          serviceNewsId = self.serviceNews[indexPath.row].id
          self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
}
