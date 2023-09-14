//
//  PolicyViewController.swift
//  FOAV
//
//  Created by hoon Kim on 11/02/2020.
//  Copyright © 2020 hoon Kim. All rights reserved.
//

import UIKit
import WebKit

class PolicyViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    var getUrl = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: getUrl)
        let request = URLRequest(url: url!)
        webView.load(request)
        webView.allowsBackForwardNavigationGestures = true
        
        
        // Do any additional setup after loading the view.
    }
    
     @IBAction func backBtn(_ sender: Any) {
         // 네비게이션을 이용한 이전화면으로 돌아가기
         self.navigationController!.popViewController(animated: true)
     }

}
