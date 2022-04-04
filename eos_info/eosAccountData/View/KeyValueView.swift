//
//  KeyValueView.swift
//  eos_info
//
//  Created by Ekaterina Nesterova on 03.04.2022.
//

import UIKit

class KeyValueView: UIView {
        
    private let keyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15)
        return stackView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        backgroundColor = .clear
        addSubview(containerStackView)
        arrangeStackViews()
    }
    
    func bind(data: KeyValueDataModel) {
        if let keyText = data.key {
            keyLabel.text = keyText
        }
        if let valueText = data.value {
            valueLabel.text = valueText
        }
    }
    
    private func arrangeStackViews() {
        containerStackView.addArrangedSubview(keyLabel)
        containerStackView.addArrangedSubview(valueLabel)
    }
    
}

struct KeyValueDataModel {
    var key: String?
    var value: String?
}
