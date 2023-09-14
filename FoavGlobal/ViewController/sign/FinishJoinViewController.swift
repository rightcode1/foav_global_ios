//
//  FinshJoinViewController.swift
//  FOAV
//
//  Created by hoon Kim on 01/10/2019.
//  Copyright © 2019 hoon Kim. All rights reserved.
//

import UIKit

class FinishJoinViewController: UIViewController {
   

    @IBAction func moveToLoginView(_ sender: Any) {
      navigationController?.popToRootViewController(animated: true)
    }
    
}
