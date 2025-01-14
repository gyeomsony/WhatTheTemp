//
//  String+Extension.swift
//  WhatTheTemp
//
//  Created by 박시연 on 1/12/25.
//

import UIKit

extension String {
    func highlightedText(for keyword: String, highlightColor: UIColor = .white) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        let range = (self as NSString).range(of: keyword, options: .caseInsensitive)
        
        if range.location != NSNotFound {
            attributedString.addAttribute(.foregroundColor, value: highlightColor, range: range)
        }
        
        return attributedString
    }
}

