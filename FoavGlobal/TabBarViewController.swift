//
//  TabBarViewController.swift
//  FOAV
//
//  Created by hoon Kim on 05/12/2019.
//  Copyright © 2019 hoon Kim. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
  
  @IBOutlet weak var mainTabBar: UITabBar!
  
  var status: Bool = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.delegate = self
    // Do any additional setup after loading the view.
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    if status {
      
    }
  }
  
  override var shouldAutorotate: Bool{
    guard let viewController = (self.selectedViewController as? UINavigationController)?.visibleViewController else{
      return true
    }
    return viewController.shouldAutorotate
  }
  
  
  
  func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
    guard let viewArray = self.viewControllers else { return }
    
  }
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
    guard let viewController = (self.selectedViewController as? UINavigationController)?.visibleViewController else{
      return [ .portrait ]
    }
    return viewController.supportedInterfaceOrientations
  }
  
  override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
    guard let viewController = (self.selectedViewController as? UINavigationController)?.visibleViewController else{
      return .portrait
    }
    return viewController.preferredInterfaceOrientationForPresentation
  }
  
  
}
// 탭바 높이 지정하기
extension UITabBar {
  override open func sizeThatFits(_ size: CGSize) -> CGSize {
    super.sizeThatFits(size)
    var sizeThatFits = super.sizeThatFits(size)
    if UIScreen.main.bounds.width >= 375 && UIScreen.main.bounds.height > 667 {
      sizeThatFits.height = 70
      return sizeThatFits
    } else {
      sizeThatFits.height = 50
      return sizeThatFits
    }
  }
}
