//
//  AccountDataManager.swift
//  eos_info
//
//  Created by Ekaterina Nesterova on 03.04.2022.
//

import Foundation

let serverUrl: String = "https://eos.greymass.com"
let accountEndpoint: String = "/v1/chain/get_account"

protocol AccountDataManagerDelegate {
    func startRequest()
    func finishedWithSuccess(_ accountData: AccountData)
    func finishedWithError(_ error: Error?)
}

class AccountDataManager {
    var delegate: AccountDataManagerDelegate?
    
    func getDataForAccount(name: String) {
        delegate?.startRequest()
        guard let accountUrl = URL(string: "\(serverUrl)\(accountEndpoint)") else {
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.finishedWithError(nil)
            }
            return
        }
        var request = URLRequest(url:accountUrl)
        request.httpMethod = "POST"

        let accountName = AccountName(accountName: name)

        do {
            let jsonData = try JSONEncoder().encode(accountName)
            request.httpBody = jsonData
        } catch let error {
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.finishedWithError(error)
            }
        }

        let task = URLSession.shared.dataTask(with: request as URLRequest) { [weak self] data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.delegate?.finishedWithError(error)
                }
                return
            }
            if let data = data {
                do {
                    let accountData = try JSONDecoder().decode(AccountData.self, from: data)
                    DispatchQueue.main.async { [weak self] in
                        self?.delegate?.finishedWithSuccess(accountData)
                    }
                } catch let error {
                    DispatchQueue.main.async { [weak self] in
                        self?.delegate?.finishedWithError(error)
                    }
                }
            } else {
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.finishedWithError(nil)
                }
            }
        }
        task.resume()
    }
    
}
