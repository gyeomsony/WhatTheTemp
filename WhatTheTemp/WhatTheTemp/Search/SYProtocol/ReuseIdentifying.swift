//
//  ReuseIdentifying.swift
//  WhatTheTemp
//
//  Created by t박시연 on 1/8/25.
//

protocol ReuseIdentifying: AnyObject {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifying {
    static var reuseIdentifier: String {
        String(describing: self)
    }
}
