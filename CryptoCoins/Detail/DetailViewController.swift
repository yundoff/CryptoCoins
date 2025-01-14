//
//  DetailViewController.swift
//  Test
//
//  Created by Aleksey Yundov on 13.01.2025.
//

import UIKit

class DetailViewController: UIViewController, DetailViewControllerProtocol {
    
    // MARK: - Properties
    private let presenter: DetailPresenterProtocol
    private var currencyData: [Detail.Response.Currency] = []

    private lazy var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    // MARK: - UI Properties
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.refreshControl = refreshControl
        return scrollView
    }()
    private lazy var detailStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [priceStackView, paramsStackView])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    private lazy var priceStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [priceLabel, changesLabel])
        stackView.spacing = 10
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var paramsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            marketCapStackView,
            stackSeparator1,
            supplyStackView,
            stackSeparator2,
            volumeStackView])
        stackView.distribution = .equalCentering
        stackView.alignment = .center
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var marketCapStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [marketCapLabel, marketCapValueLabel])
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var supplyStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [supplyLabel, supplyValueLabel])
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var volumeStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [volumeLabel, volumeValueLabel])
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.text = "..."
        label.textColor = .white
        label.font = label.font.withSize(24)
        label.numberOfLines = 0
        return label
    }()
    
    private let changesLabel: UILabel = {
        let label = UILabel()
        label.text = "..."
        label.textColor = Resources.Colors.changeGreen
        label.font = label.font.withSize(14)
        return label
    }()
    
    private let marketCapLabel: UILabel = {
        let label = UILabel()
        label.text = "Market Cap"
        label.textColor = .white
        label.layer.opacity = 0.5
        label.font = label.font.withSize(12)
        label.sizeToFit()
        return label
    }()
    
    private let marketCapValueLabel: UILabel = {
        let label = UILabel()
        label.text = "..."
        label.textColor = .white
        label.font = label.font.withSize(16)
        label.sizeToFit()
        return label
    }()
    
    
    private let supplyLabel: UILabel = {
        let label = UILabel()
        label.text = "Supply"
        label.textColor = .white
        label.layer.opacity = 0.5
        label.font = label.font.withSize(12)
        label.sizeToFit()
        return label
    }()
    
    private let supplyValueLabel: UILabel = {
        let label = UILabel()
        label.text = "..."
        label.textColor = .white
        label.font = label.font.withSize(16)
        label.sizeToFit()
        return label
    }()
    
    
    private let volumeLabel: UILabel = {
        let label = UILabel()
        label.text = "Volume 24Hr"
        label.textColor = .white
        label.layer.opacity = 0.5
        label.font = label.font.withSize(12)
        label.sizeToFit()
        return label
    }()
    
    private let volumeValueLabel: UILabel = {
        let label = UILabel()
        label.text = "..."
        label.textColor = .white
        label.font = label.font.withSize(16)
        label.sizeToFit()
        return label
    }()
    
    private let stackSeparator1: UIImageView = {
        let separator = UIImageView()
        separator.image = UIImage(resource: .separator)
        return separator
    }()
    
    private let stackSeparator2: UIImageView = {
        let separator = UIImageView()
        separator.image = UIImage(resource: .separator)
        return separator
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = label.font.withSize(24)
        return label
    }()
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "back"), for: .normal)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        refreshControl.tintColor = .white
        return refreshControl
    }()
    
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
        setupViews()
        setupCustomNavigationBar(with: "...")
        presenter.requestDetailCurrencyData()
    }
    
    // MARK: - MainControllerProtocol
    func display(models: [Detail.Response.Currency]) {
        currencyData = models
        models.forEach { model in
            setup(model: model)
        }
        refreshControl.endRefreshing()
    }

    
    func displayError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - Private Methods
    private func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(detailStackView)

        view.backgroundColor = UIColor(patternImage: UIImage(named: "background") ?? UIImage())
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        detailStackView.snp.makeConstraints {
            $0.width.equalToSuperview()
        }
    }
    
    private func setupCustomNavigationBar(with title: String) {
        titleLabel.text = title
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        let titleBarButtonItem = UIBarButtonItem(customView: titleLabel)
        
        navigationItem.leftBarButtonItems = [backBarButtonItem, titleBarButtonItem]
    }
    
    // MARK: - Actions
    @objc
    private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func refreshData(_ sender: UIRefreshControl) {
        presenter.requestDetailCurrencyData()
    }
    // MARK: -  Methods
    func setup(model: Detail.Response.Currency) {
        setupCustomNavigationBar(with: model.name)
        let currencyFormatter: (String, String) -> String = { value, symbol in
            if let number = Double(value.replacingOccurrences(of: symbol, with: "").replacingOccurrences(of: ",", with: "")) {
                return "\(symbol == "$" ? "$" : "")\(number.formattedWithSuffix())"
            } else {
                return value
            }
        }
        
        priceLabel.text = currencyFormatter(model.price, "$")
        marketCapValueLabel.text = currencyFormatter(model.marketCap.replacingOccurrences(of: "b", with: ""), "$")
        supplyValueLabel.text = currencyFormatter(model.supply.replacingOccurrences(of: "m", with: ""), "")
        volumeValueLabel.text = currencyFormatter(model.volume24Hr.replacingOccurrences(of: "b", with: ""), "$")
        
        if let change = Double(model.change.replacingOccurrences(of: "%", with: "")) {
            changesLabel.text = "\(change.formattedWithSuffix())%"
            changesLabel.textColor = change > 0 ? Resources.Colors.changeGreen : Resources.Colors.changeRed
        } else {
            changesLabel.text = model.change
        }
    }

}
