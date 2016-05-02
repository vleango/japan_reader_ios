//
//  ReadIndexCell.swift
//  japanese-memo
//
//  Created by Tha Leang on 5/3/16.
//  Copyright © 2016 Tha Leang. All rights reserved.
//

import UIKit

class ReadIndexCell: UITableViewCell {

    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    var article:Article!
    
    func configureCell(article: Article) {
        self.article = article
        titleLabel.text = article.title
    }
}
