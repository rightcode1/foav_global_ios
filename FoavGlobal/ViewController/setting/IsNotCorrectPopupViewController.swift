//
//  IsNotCorrectPopupViewController.swift
//  FOAV
//
//  Created by hoonKim on 2021/02/23.
//  Copyright © 2021 hoon Kim. All rights reserved.
//

import UIKit

class IsNotCorrectPopupViewController: UIViewController {
  
  @IBOutlet weak var finishView: UIView!{
      didSet{
          finishView.layer.cornerRadius = 11
      }
  }
  
  @IBOutlet weak var finishBtn: UIButton!{
    didSet{
      finishBtn.layer.cornerRadius = 5
    }
}
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  
  
}
