//
//  DetailViewController.swift
//  CryptoCoins
//
//  Created by Aleksey Yundov on 13.01.2025.
//

import UIKit

protocol DetailViewControllerProtocol: AnyObject {
    
    func display(_ initialData: Detail.InitialData)
    func display(_ currencies: [Detail.Currency])
    func display(_ error: Detail.Error)
    
    func setup(model: Detail.Currency)
    func setupCustomNavigationBar(name: String)
}

class DetailViewController: UIViewController {
    
    // MARK: - Nested Types

    enum constants {
        static let inset: CGFloat = 20
        static let spacing: CGFloat = 10
        static let bigFontSize: CGFloat = 24
        static let middleFontSize: CGFloat = 16
        static let smallFontSize: CGFloat = 12
        static let zero: CGFloat = 0
    }
    
    // MARK: - Properties
    
    private let presenter: DetailPresenterProtocol
    private var currencies: [Detail.Currency] = []
    
    // MARK: - Views
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.refreshControl = refreshControl
        return scrollView
    }()
    
    private lazy var detailStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [priceStackView, paramsStackView])
        
        stackView.axis = .vertical
        stackView.spacing = constants.spacing
        
        stackView.layoutMargins = UIEdgeInsets(
            top: constants.inset,
            left: constants.inset,
            bottom: constants.zero,
            right: constants.inset)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        return stackView
    }()
    
    private lazy var priceStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [priceLabel, changesLabel])
        stackView.spacing = constants.spacing
        stackView.alignment = .center
        return stackView
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.font = label.font.withSize(constants.bigFontSize)
        return label
    }()
    
    private let changesLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = label.font.withSize(constants.middleFontSize)
        return label
    }()
    
    private lazy var paramsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            marketCapStackView,
            firstStackSeparator,
            supplyStackView,
            secondStackSeparator,
            volumeStackView])
        
        stackView.spacing = constants.spacing
        stackView.distribution = .equalCentering
        stackView.alignment = .center
        
        return stackView
    }()
    
    private lazy var marketCapStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [marketCapLabel, marketCapValueLabel])
        stackView.axis = .vertical
        stackView.spacing = constants.spacing
        return stackView
    }()
    
    private let marketCapLabel: UILabel = {
        let label = UILabel()
        label.layer.opacity = 0.5
        label.textColor = .white
        label.font = label.font.withSize(constants.smallFontSize)
        return label
    }()
    
    private let marketCapValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = label.font.withSize(constants.middleFontSize)
        return label
    }()
    
    private let firstStackSeparator: UIImageView = {
        let separator = UIImageView()
        return separator
    }()
    
    private lazy var supplyStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [supplyLabel, supplyValueLabel])
        stackView.axis = .vertical
        stackView.spacing = constants.spacing
        return stackView
    }()
    
    private let supplyLabel: UILabel = {
        let label = UILabel()
        label.layer.opacity = 0.5
        label.textColor = .white
        label.font = label.font.withSize(constants.smallFontSize)
        return label
    }()
    
    private let supplyValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = label.font.withSize(constants.middleFontSize)
        return label
    }()
    
    private let secondStackSeparator: UIImageView = {
        let separator = UIImageView()
        return separator
    }()
    
    private lazy var volumeStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [volumeLabel, volumeValueLabel])
        stackView.axis = .vertical
        stackView.spacing = constants.spacing
        return stackView
    }()
    
    private let volumeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.layer.opacity = 0.5
        label.font = label.font.withSize(constants.smallFontSize)
        return label
    }()
    
    private let volumeValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = label.font.withSize(constants.middleFontSize)
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = label.font.withSize(constants.bigFontSize)
        return label
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        
        refreshControl.tintColor = .white
        
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
        return refreshControl
    }()
    
    // MARK: - Actions
    
    @objc
    private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func refreshData(_ sender: UIRefreshControl) {
        presenter.requestAssets()
    }
    
    // MARK: - Init
    
    init(presenter: DetailPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCustomNavigationBar(name: "")
        setupViews()
        
        presenter.requestInitialData()
        presenter.requestAssets()
    }
    
    // MARK: - Setup Views
    
    private func setupViews() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        scrollView.addSubview(detailStackView)
        detailStackView.snp.makeConstraints { $0.width.equalToSuperview() }
    }
    
    func setupCustomNavigationBar(name: String) {
        titleLabel.text = name
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        let titleBarButtonItem = UIBarButtonItem(customView: titleLabel)
        
        navigationItem.leftBarButtonItems = [backBarButtonItem, titleBarButtonItem]
        
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    func setup(model: Detail.Currency) {
        
        setupCustomNavigationBar(name: model.name)
        
        priceLabel.text = model.price
        marketCapLabel.text = Localizable.Detail.marketCapTitle
        marketCapValueLabel.text = model.marketCap
        supplyLabel.text = Localizable.Detail.supplyTitle
        supplyValueLabel.text = model.supply
        volumeLabel.text = Localizable.Detail.volumeTitle
        volumeValueLabel.text = model.volume
        changesLabel.text = model.change
        changesLabel.textColor = model.change.contains("-") ? .init(resource: .changeRed) : .init(resource: .changeGreen)
    }
}

// MARK: - DetailViewControllerProtocol

extension DetailViewController: DetailViewControllerProtocol {
    
    func display(_ initialData: Detail.InitialData) {
        firstStackSeparator.image = initialData.separatorImage
        secondStackSeparator.image = initialData.separatorImage
        backButton.setImage(initialData.backButtonImage, for: .normal)
        view.backgroundColor = UIColor(patternImage: initialData.backgroundImage)
    }
    
    func display(_ currency: [Detail.Currency]) {
        guard let currency = currency.first else { return }
        setup(model: currency)
        refreshControl.endRefreshing()
    }
    
    func display(_ error: Detail.Error) {
        let alert = UIAlertController(
            title: error.title,
            message: error.message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: error.buttonTitle, style: .default))
        
        present(alert, animated: true)
    }
}
