//
//  AgreeViewController.swift
//  FOAV
//
//  Created by hoonKim on 2020/06/29.
//  Copyright © 2020 hoon Kim. All rights reserved.
//

import UIKit
import WebKit

enum AgreeCategory: String, Codable {
  case info
  case use
  case location
}

class AgreeViewController: UIViewController {
  @IBOutlet var webView: WKWebView!
  
  var agreeCategory: AgreeCategory = .info
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    switch agreeCategory {
      case .info:
        self.request(url: "https://foav.co.kr/userPolicyGlobal.html")
      case .use:
        self.request(url: "https://foav.co.kr/policy/usePolicy.html")
      case .location:
        self.request(url: "https://foav.co.kr/locPolicyGlobal.html")
    }
  }
  
  func request(url: String) {
      self.webView.load(URLRequest(url: URL(string: url)!))
  }
  
}
