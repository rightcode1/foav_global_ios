//
//  noticeTableViewCell.swift
//  FOAV
//
//  Created by hoon Kim on 21/10/2019.
//  Copyright © 2019 hoon Kim. All rights reserved.
//
import UIKit
import Foundation

class noticeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var noticeTitleLabel: UILabel!
    @IBOutlet weak var noticeDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
}

