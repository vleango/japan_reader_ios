//
//  MainTabBarController.swift
//  japanese-memo
//
//  Created by Tha Leang on 4/30/16.
//  Copyright © 2016 Tha Leang. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    struct storyboards {
        static let search =     (storyboard: "Search",      identifier: "SearchNavVC")
        static let read =       (storyboard: "Read",        identifier: "ReadNavVC")
        static let favorite =   (storyboard: "Favorite",    identifier: "FavoriteNavVC")
        static let option =   (storyboard: "Option",    identifier: "OptionNavVC")
    }
    
    let searchVC = UIStoryboard.init(name: storyboards.search.storyboard, bundle: nil).instantiateViewControllerWithIdentifier(storyboards.search.identifier)
    let readVC = UIStoryboard.init(name: storyboards.read.storyboard, bundle: nil).instantiateViewControllerWithIdentifier(storyboards.read.identifier)
    let favoriteVC = UIStoryboard.init(name: storyboards.favorite.storyboard, bundle: nil).instantiateViewControllerWithIdentifier(storyboards.favorite.identifier)
    let optionVC = UIStoryboard.init(name: storyboards.option.storyboard, bundle: nil).instantiateViewControllerWithIdentifier(storyboards.option.identifier)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setViewControllers([searchVC, readVC, favoriteVC, optionVC], animated: true)
    }

}
