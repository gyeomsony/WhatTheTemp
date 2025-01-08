//
//  SearchListViewController.swift
//  WhatTheTemp
//
//  Created by t2023-m0019 on 1/8/25.
//

import UIKit

final class SearchListViewController: UIViewController {
    var searchQuery: String?
    let searchListView = SearchListView()

    override func loadView() {
        super.loadView()
        self.view = searchListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1.0)
    }
}
