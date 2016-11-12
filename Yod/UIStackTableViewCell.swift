//
//  UIStackTableViewCell.swift
//  Yod
//
//  Created by Enterprise Open Source Solution on 11/8/2559 BE.
//  Copyright © 2559 Enterprise Open Source Solution. All rights reserved.
//

import UIKit

class UIStackTableViewCell: UITableViewCell {

    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var stackView: StackView!
    @IBOutlet weak var peLabel: UILabel!
    @IBOutlet weak var lastLabel: UILabel!
    @IBOutlet weak var predictLabel: UILabel!
    @IBOutlet weak var predictChgLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
