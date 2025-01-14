//
//  MainTableViewCell.swift
//  Test
//
//  Created by Aleksey Yundov on 13.01.2025.
//

import UIKit

final class MainTableViewCell: UITableViewCell {
    
    // MARK: - Nested Types
    static let id = "MainTableViewCell"
    
    // MARK: - UI Properties
    private lazy var tableStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [tableImageView, titleStackView, priceStackView])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
        stackView.layoutMargins = UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let tableImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [currencyLabel, abbreviationLabel])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 2
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let currencyLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(16)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let abbreviationLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(14)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var priceStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [priceLabel, changesLabel])
        stackView.axis = .vertical
        stackView.alignment = .trailing
        stackView.spacing = 2
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(16)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let changesLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(14)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupSelectedBackground()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func setupViews() {
        setupSubviews()
        setupLayout()
    }
    
    private func setupSubviews() {
        backgroundColor = .clear
        contentView.addSubview(tableStackView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            tableImageView.widthAnchor.constraint(equalToConstant: 48),
            tableImageView.heightAnchor.constraint(equalToConstant: 48),
            
            tableStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tableStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tableStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            tableStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func setupSelectedBackground() {
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        selectedBackgroundView = selectedView
    }

    // MARK: -  Methods
    func setup(model: Main.Response.Currency) {
        let defaultImage = UIImage(named: "defaultImage")
        let imageName = model.symbol.lowercased()
        tableImageView.image = UIImage(named: imageName) ?? defaultImage
        currencyLabel.text = model.name
        abbreviationLabel.text = model.symbol
        
        let formatCurrency: (String, String) -> String = { value, symbol in
            if let number = Double(value.replacingOccurrences(of: symbol, with: "").replacingOccurrences(of: ",", with: "")) {
                return "\(symbol == "$" ? "$" : "")\(number.formattedWithSuffix())"
            } else {
                return value
            }
        }
        priceLabel.text = formatCurrency(model.price, "$")
        
        if let change = Double(model.change.replacingOccurrences(of: "%", with: "")) {
            changesLabel.text = "\(change.formattedWithSuffix())%"
            changesLabel.textColor = change > 0 ? Resources.Colors.changeGreen : Resources.Colors.changeRed
        } else {
            changesLabel.text = model.change
        }
    }
}

