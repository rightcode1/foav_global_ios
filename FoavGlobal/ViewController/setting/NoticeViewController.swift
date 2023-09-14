//
//  NoticeViewController.swift
//  FOAV
//
//  Created by hoon Kim on 21/10/2019.
//  Copyright © 2019 hoon Kim. All rights reserved.
//

import UIKit

class NoticeViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var noticeTableView: UITableView!{
        didSet{
            
        }
    }
    
    var notice = [Notices.NoticeRows]()
    
    var noticeId:Int = 0
    var diff: String = ""
    
    let cellIdentifier = "noticeCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        noticeTableView.delegate = self
        noticeTableView.dataSource = self
        
        registerXib()
        
        DispatchQueue.global().sync {
                getNoticeInfo()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func registerXib() {
        let nibName = UINib(nibName: "noticeCell", bundle: nil)
        noticeTableView.register(nibName, forCellReuseIdentifier: cellIdentifier)
    }
    
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
    func getNoticeInfo() {
        ApiService.request(router: SettingApi.notice, success: { (response: ApiResponse<NoticeResponse>) in
            guard let value = response.value else {
                return
            }
            self.notice = value.notices.rows
            self.noticeTableView.reloadData()
            
            if value.result {
                UserDefaults.standard.set(value.notices.count, forKey: "noticeListIndex")
            }
            
        }) { (error) in
            self.doAlert(message: "알수없는 오류입니다.\n잠시후 다시 시도해주세요.")
        }
        
    }
    
}

extension NoticeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notice.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = noticeTableView.dequeueReusableCell(withIdentifier: "noticeCell", for: indexPath) as! noticeTableViewCell
        cell.noticeDateLabel.text = notice[indexPath.row].title
        cell.noticeTitleLabel.text = String(notice[indexPath.row].createdAt.unicodeScalars.prefix(10))
        cell.separatorInset = UIEdgeInsets.zero
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                let vc = UIStoryboard(name: "Setting", bundle: nil).instantiateViewController(withIdentifier: "noticeDetail") as! NoticeDetailViewController
                    noticeDetailId = notice[indexPath.row].id 
        
                 self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
}



