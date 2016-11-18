//
//  UIHeaderTableViewCell.swift
//  Yod
//
//  Created by Enterprise Open Source Solution on 11/10/2559 BE.
//  Copyright © 2559 Enterprise Open Source Solution. All rights reserved.
//

import UIKit

class UIHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var netButton: UIButton!
    @IBOutlet weak var growthButton: UIButton!
    @IBOutlet weak var pebutton: UIButton!
    @IBOutlet weak var lastButton: UIButton!
    @IBOutlet weak var predictButton: UIButton!
    @IBOutlet weak var predictChgButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
