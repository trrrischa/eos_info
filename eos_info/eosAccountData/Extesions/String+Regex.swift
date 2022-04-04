//
//  String+Regex.swift
//  eos_info
//
//  Created by Ekaterina Nesterova on 03.04.2022.
//

extension String {
    func matches(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}
