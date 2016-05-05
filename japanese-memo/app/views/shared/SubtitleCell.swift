//
//  SubtitleCell.swift
//  japanese-memo
//
//  Created by Tha Leang on 5/5/16.
//  Copyright © 2016 Tha Leang. All rights reserved.
//

import UIKit

class SubtitleCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    var entry:Entry!
    
    
    func configureCell(title:String, subtitle:String) {
        self.titleLabel.text = title
        self.subtitleLabel.text = subtitle
    }

}
