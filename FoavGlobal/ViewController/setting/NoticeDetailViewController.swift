//
//  NoticeDetailViewController.swift
//  FOAV
//
//  Created by hoon Kim on 21/10/2019.
//  Copyright © 2019 hoon Kim. All rights reserved.
//

import UIKit
import Foundation

class NoticeDetailViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var noticeContentTV: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        getNoticeDetailInfo()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
            
    
    


    @IBAction func backBtn(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
//
    func getNoticeDetailInfo() {
        ApiService.request(router: SettingApi.noticeDetail, success: {  (response: ApiResponse<NoticeDetailResponse>) in
            guard let value = response.value else {
                        return
            }
            self.dateLabel.text = String(value.notice.createdAt.unicodeScalars.prefix(10))
            self.TitleLabel.text = value.notice.title
            self.noticeContentTV.text = value.notice.content
            
            if value.result {
                print("-^^^^^^^^^^^^^^-데이터가져왔당")
            }

            }) { (error) in
            self.doAlert(message: "알수없는 오류입니다.\n잠시후 다시 시도해주세요.")
                }
       
    }
    
}

