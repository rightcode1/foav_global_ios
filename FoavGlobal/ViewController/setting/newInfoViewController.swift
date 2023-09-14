//
//  newInfoViewController.swift
//  FOAV
//
//  Created by hoon Kim on 15/10/2019.
//  Copyright © 2019 hoon Kim. All rights reserved.
//

import UIKit

class newInfoViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var news = [RowsNews
    ]()
    var diff: String = ""
    
    @IBOutlet weak var newInfoListView: UITableView!
    
    
    let cellIdentifier = "newInfoCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        newInfoListView.delegate = self
        newInfoListView.dataSource = self
        
            if diff == "foav"{
                getFoavNewsListInfo()
            }else{
                getNewsListInfo()
            }
        registerXib()
    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func registerXib() {
        let nibName = UINib(nibName: "newInfoCell", bundle: nil)
        newInfoListView.register(nibName, forCellReuseIdentifier: cellIdentifier)
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }

    func getNewsListInfo() {
        ApiService.request(router: SettingApi.news, success: { (response: ApiResponse<NewsResponse>) in
            guard let value = response.value else {
                return
            }
            self.news = value.newsList.rows
            self.newInfoListView.reloadData()
            
            if value.result {
                print("!!!#@$#@$#@$#@$#@$#@$#@$#@$\(value.newsList)")
                UserDefaults.standard.set(value.newsList.count, forKey: "newsListIndex") 
            }
            
        }) { (error) in
            self.doAlert(message: "소식 정보를 받아올 수 없습니다. \n 다시 시도해주세요.")
        }
        
    }
    func getFoavNewsListInfo() {
        ApiService.request(router: SettingApi.foavnews, success: { (response: ApiResponse<NewsFoavResponse>) in
            guard let value = response.value else {
                return
            }
            self.news = value.newsList
            self.newInfoListView.reloadData()
            
            if value.result {
                print("!!!#@$#@$#@$#@$#@$#@$#@$#@$\(value.newsList)")
//                UserDefaults.standard.set(value.newsList.count(), forKey: "newsListIndex")
            }
            
        }) { (error) in
            self.doAlert(message: "소식 정보를 받아올 수 없습니다. \n 다시 시도해주세요.")
        }
        
    }
    

}

extension newInfoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = newInfoListView.dequeueReusableCell(withIdentifier: "newInfoCell", for: indexPath) as! newInfoTableViewCell
        cell.newInfoLabel.text = news[indexPath.row].title
        cell.dateLabel.text = String(news[indexPath.row].createdAt.unicodeScalars.prefix(10))
        cell.separatorInset = UIEdgeInsets.zero
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Setting", bundle: nil).instantiateViewController(withIdentifier: "newsDetailVC") as! NewInfoDetailViewController
        newsDetailId = news[indexPath.row].id
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
}
