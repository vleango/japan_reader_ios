//
//  SearchCell.swift
//  japanese-memo
//
//  Created by Tha Leang on 5/5/16.
//  Copyright © 2016 Tha Leang. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    var entry:Entry!
    
    func configureCell(entry: Entry) {
        self.titleLabel.attributedText = NSAttributedString(string: "\(entry.kElesAsString())「\(entry.rEleAsString())」")
        self.subtitleLabel.attributedText = NSAttributedString(string: entry.glossAsString())
    }

}
