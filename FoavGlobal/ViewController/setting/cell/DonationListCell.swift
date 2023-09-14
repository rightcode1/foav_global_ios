//
//  DonationListCell.swift
//  FOAV
//
//  Created by hoon Kim on 09/01/2020.
//  Copyright © 2020 hoon Kim. All rights reserved.
//

import UIKit

class DonationListCell: UITableViewCell {
    @IBOutlet weak var companyLb: UILabel!
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var dateLb: UILabel!
    @IBOutlet weak var payLb: UILabel!
    @IBOutlet weak var payTypeLb: UILabel!
    @IBOutlet weak var myDonationView: UIView!{
        didSet{
            myDonationView.layer.cornerRadius = 5
            myDonationView.layer.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            myDonationView.layer.shadowOpacity = 1
            myDonationView.layer.shadowOffset = CGSize(width: 0, height: 0)
            myDonationView.layer.shadowRadius = 2
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
