//
//  AccountViewController.swift
//  eos_info
//
//  Created by Ekaterina Nesterova on 03.04.2022.
//

import Foundation
import UIKit

class AccountViewController: UIViewController {
    @IBOutlet weak var accountNameTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var accountInfoStackView: UIStackView!
    
    var dataManager = AccountDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        accountNameTextField.delegate = self
        activityIndicator.isHidden = true
        dataManager.delegate = self
    }
            
    @IBAction func getInfoTapped(_ sender: Any) {
        view.endEditing(true)
        sendRequest()
    }
    
    func showError (title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {_ in
            alert.dismiss(animated: true)
        })
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    func sendRequest() {
        guard let accountName = accountNameTextField.text else { return }
        dataManager.getDataForAccount(name: accountName)
    }
    
    func reloadAccountInfo(_ accountData: AccountData) {
        accountInfoStackView.subviews.forEach({ $0.removeFromSuperview() })
        if let eosBalance = accountData.coreLiquidBalance {
            let eosBalanceData = KeyValueDataModel(key: "EOS balance", value: eosBalance)
            let eosBalanceInfoView = KeyValueView()
            eosBalanceInfoView.bind(data: eosBalanceData)
            accountInfoStackView.addArrangedSubview(eosBalanceInfoView)
        }
        if let cpuStaked = accountData.cpuLimit?.used {
            let cpuStakedData = KeyValueDataModel(key: "CPU staked", value: "\(cpuStaked)")
            let cpuStakedInfoView = KeyValueView()
            cpuStakedInfoView.bind(data: cpuStakedData)
            accountInfoStackView.addArrangedSubview(cpuStakedInfoView)
        }
        if let cpuCurrent = accountData.cpuLimit?.available {
            let cpuCurrentData = KeyValueDataModel(key: "CPU current", value: "\(cpuCurrent)")
            let cpuCurrentInfoView = KeyValueView()
            cpuCurrentInfoView.bind(data: cpuCurrentData)
            accountInfoStackView.addArrangedSubview(cpuCurrentInfoView)
        }
        if let netStaked = accountData.netLimit?.used {
            let netStakedData = KeyValueDataModel(key: "NET staked", value: "\(netStaked)")
            let netStakedInfoView = KeyValueView()
            netStakedInfoView.bind(data: netStakedData)
            accountInfoStackView.addArrangedSubview(netStakedInfoView)
        }
        if let netCurrent = accountData.cpuLimit?.available {
            let netCurrentData = KeyValueDataModel(key: "NET current", value: "\(netCurrent)")
            let netCurrentInfoView = KeyValueView()
            netCurrentInfoView.bind(data: netCurrentData)
            accountInfoStackView.addArrangedSubview(netCurrentInfoView)
        }
        if let ramUsage = accountData.ramUsage {
            let ramUsageData = KeyValueDataModel(key: "RAM usage", value: "\(ramUsage)")
            let ramUsageInfoView = KeyValueView()
            ramUsageInfoView.bind(data: ramUsageData)
            accountInfoStackView.addArrangedSubview(ramUsageInfoView)
        }
        if let ramQuota = accountData.ramQuota,
           let ramUsage = accountData.ramUsage {
            let ramFreeData = KeyValueDataModel(key: "RAM free", value: "\(ramQuota - ramUsage)")
            let ramFreeInfoView = KeyValueView()
            ramFreeInfoView.bind(data: ramFreeData)
            accountInfoStackView.addArrangedSubview(ramFreeInfoView)
        }
        accountInfoStackView.addArrangedSubview(UIView())
    }
}

extension AccountViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if let text = textField.text,
           let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)
            if updatedText.matches("[a-z1-5\\.]{1,12}") {
                return true
            } else if updatedText.count > 0 {
                showError(title: "Not Valid Name",
                          message: "Please, enter a valid eos account name")
                return false
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendRequest()
        return true
    }
}

extension AccountViewController: AccountDataManagerDelegate {
    func startRequest() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func finishedWithSuccess(_ accountData: AccountData) {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        reloadAccountInfo(accountData)
    }
    
    func finishedWithError(_ error: Error?) {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        guard let error = error else {
            showError(title: "Network Error",
                      message: "Something went wrong")
            return
        }
        showError(title: "Network Error", message: error.localizedDescription)
    }
    
}
