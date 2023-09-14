//
//  FindMyId_2ViewController.swift
//  FOAV
//
//  Created by hoon Kim on 23/10/2019.
//  Copyright © 2019 hoon Kim. All rights reserved.
//

import UIKit

class FindMyId_2ViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var findId = ""
    @IBOutlet weak var findIdLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        findIdLabel.text = findId
    }
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func moveToSignViewBtn(_ sender: UIButton) {
      navigationController?.popToRootViewController(animated: true)
    }
    
}
