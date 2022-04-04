//
//  AccountName.swift
//  eos_info
//
//  Created by Ekaterina Nesterova on 03.04.2022.
//

// MARK: - AccountName
struct AccountName: Codable {
    let accountName: String?

    enum CodingKeys: String, CodingKey {
        case accountName = "account_name"
    }
}
