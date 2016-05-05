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
        var k_eleText:[String] = []
        for k_ele in entry.k_eles {
            k_eleText.append(k_ele.keb)
        }
        
        var r_eleText:[String] = []
        for r_ele in entry.r_eles {
            r_eleText.append(r_ele.reb)
        }
        
        self.titleLabel.attributedText = NSAttributedString(string: "\(k_eleText.joinWithSeparator(", "))「\(r_eleText.joinWithSeparator(", "))」")
        var senseText:[String] = []
        for sense in entry.senses {
            senseText.append(sense.glossesAsString())
        }
        self.subtitleLabel.attributedText = NSAttributedString(string: senseText.joinWithSeparator(", "))
    }

}
