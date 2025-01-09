//
//  SearchResultListViewController.swift
//  WhatTheTemp
//
//  Created by t2023-m0019 on 1/8/25.
//

import UIKit

final class SearchResultListViewController: UIViewController {
    var searchQuery: String?
    let searchResultListView = SearchResultListView()

    override func loadView() {
        super.loadView()
        self.view = searchResultListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
