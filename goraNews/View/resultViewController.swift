//
//  resultViewController.swift
//  goraNews
//
//  Created by Yegor Geronin on 13.03.2022.
//

import Foundation

class resultViewController: mainViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public func search(articleContains: String) {
        mainPresenter?.searchInCD(contains: articleContains)
        print(articleContains)
    }
}
