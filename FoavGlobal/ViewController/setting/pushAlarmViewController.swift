//
//  pushAlarmViewController.swift
//  FOAV
//
//  Created by hoon Kim on 15/10/2019.
//  Copyright © 2019 hoon Kim. All rights reserved.
//

import UIKit
//import FirebaseMessaging
import UserNotifications

class pushAlarmViewController: UIViewController, UIGestureRecognizerDelegate {
  @IBOutlet weak var pushStatusSwitch: UISwitch!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.interactivePopGestureRecognizer?.delegate = self
    ApiService.request(router: SettingApi.lookUpNotificationStatus, success: { (response: ApiResponse<NotificationStatusResponse>) in
      guard let value = response.value else {
        return
      }
      
      if value.result {
        print(value.user.notification)
        if value.user.notification == "on" {
          self.pushStatusSwitch.isOn = true
        } else {
          self.pushStatusSwitch.isOn = false
        }
      }
      
    }) { (error) in
      self.doAlert(message: "알수없는 오류 입니다. \n 다시 시도해주세요.")
    }
    
  }
  
  
  @IBAction func pushAlarmSwitch(_ sender: UISwitch) {
    
    if sender.isOn {
      print("isOn")
      self.showToast(message: "알림이 켜졌습니다.")
      ApiService.request(router: SettingApi.switchNotification, success: { (response: ApiResponse<NotificationSwitchResponse>) in
        guard let value = response.value else {
          return
        }
        if value.result {
          
          if value.user.notification == "off" {
            self.pushSwitch()
            print(value.user.notification)
          }
        }
        
      }) { (error) in
        self.doAlert(message: "알수없는 오류 입니다.  \n 다시 시도해주세요.")
      }
      
    } else {
      self.showToast(message: "알림이 꺼졌습니다.")
      ApiService.request(router: SettingApi.switchNotification, success: { (response: ApiResponse<NotificationSwitchResponse>) in
        guard let value = response.value else {
          return
        }
        if value.result {
          
          if value.user.notification == "on" {
            self.pushSwitch()
            print(value.user.notification)
          }
        }
        
      }) { (error) in
        self.doAlert(message: "알수없는 오류 입니다.  \n 다시 시도해주세요.")
      }
      print("isOff")
    }
  }
  
  
  func pushSwitch() {
    ApiService.request(router: SettingApi.switchNotification, success: { (response: ApiResponse<NotificationSwitchResponse>) in
      guard let value = response.value else {
        return
      }
      if value.result {
        
      }
      
    }) { (error) in
      self.doAlert(message: "알수없는 오류 입니다.  \n 다시 시도해주세요.")
    }
  }
  @IBAction func questionBtn(_ sender: UIButton) {
  }
  @IBAction func backBtn(_ sender: Any) {
    self.navigationController!.popViewController(animated: true)
  }
}

extension pushAlarmViewController: UNUserNotificationCenterDelegate {
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    print("\(#function)")
  }
}
extension UIApplication {
  class func openAppSettings() {
    
  }
}
