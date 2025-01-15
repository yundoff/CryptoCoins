//
//  MainTableViewCell.swift
//  CryptoCoins
//
//  Created by Aleksey Yundov on 13.01.2025.
//

import UIKit
import SnapKit

final class MainTableViewCell: UITableViewCell {
    
    // MARK: - Nested Types
    
    static let id = "MainTableViewCell"
    
    enum constants {
        static let horizontalInset: CGFloat = 20
        static let verticalInset: CGFloat = 12
        static let horizontalSpacing: CGFloat = 10
        static let verticalSpacing: CGFloat = 2
        static let middleFontSize: CGFloat = 16
        static let smallFontSize: CGFloat = 14
        static let imageSize: CGFloat = 48
    }
    
    // MARK: - Views
    
    private lazy var tableStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [tableImageView, titleStackView, priceStackView])
        
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = constants.horizontalSpacing
        
        stackView.layoutMargins = UIEdgeInsets(
            top: constants.verticalInset,
            left: constants.horizontalInset,
            bottom:  constants.verticalInset,
            right: constants.horizontalInset)
        
        return stackView
    }()
    
    private let tableImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [currencyLabel, abbreviationLabel])
        
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = constants.verticalSpacing
        
        return stackView
    }()
    
    private let currencyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = label.font.withSize(constants.middleFontSize)
        return label
    }()
    
    private let abbreviationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = label.font.withSize(constants.smallFontSize)
        return label
    }()
    
    private lazy var priceStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [priceLabel, changesLabel])
        
        stackView.axis = .vertical
        stackView.alignment = .trailing
        stackView.spacing = 2
        stackView.isLayoutMarginsRelativeArrangement = true
        
        return stackView
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = label.font.withSize(constants.middleFontSize)
        return label
    }()
    
    private let changesLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(constants.smallFontSize)
        return label
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Views
    
    private func setupViews() {
        setupSubviews()
    }
    
    private func setupSubviews() {
        selectionStyle = .none
        backgroundColor = .clear
        
        tableImageView.snp.makeConstraints { $0.size.equalTo(constants.imageSize) }
        
        contentView.addSubview(tableStackView)
        tableStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(constants.horizontalInset)
            $0.verticalEdges.equalToSuperview().inset(constants.verticalInset)
        }
    }
    
    func setup(model: Main.Currency) {
        let defaultImage = UIImage(resource: .default)
        let imageName = model.symbol.lowercased()
        tableImageView.image = UIImage(named: imageName) ?? defaultImage
        currencyLabel.text = model.name
        abbreviationLabel.text = model.symbol
        priceLabel.text = model.price
        changesLabel.text = model.change
        changesLabel.textColor = model.change.contains("-") ? .init(resource: .changeRed) : .init(resource: .changeGreen)
    }
}