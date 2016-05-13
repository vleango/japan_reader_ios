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
    @IBOutlet weak var subtitleLabel: UILabel!
    var article:Article!
    
    func configureCell(article: Article) {
        self.article = article
        titleLabel.text = article.title
        
        var subtitle = article.provider
        if let validPublishedDate = article.prettyPublishedDate() {
            subtitle += " | \(validPublishedDate)"
        }
        subtitleLabel.text = subtitle
    }
}
