//
//  ReadWordController.swift
//  japanese-memo
//
//  Created by Tha Leang on 5/4/16.
//  Copyright © 2016 Tha Leang. All rights reserved.
//

import UIKit
import SwiftyJSON

class ReadWordController: UIViewController {
    
    var artibutedWord:ArtibutedWord!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = CGSizeMake(200, 100)
        textView.attributedText = artibutedWord.attributedString
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func loadData() {
        NetworkManager.translation(artibutedWord.bit.word) { (success, object) in
            if success {
                if let rawJSON = object {
                    let json = JSON(rawJSON)
                    let entriesJson = json["entries"]
                    for (_, entry):(String, JSON) in entriesJson {
                        self.artibutedWord.entries.append(Entry.init(json: entry))
                    }
                }

                self.artibutedWord.showSense = true
                self.textView.attributedText = self.artibutedWord.attributedString
            }
        }
    }

}
