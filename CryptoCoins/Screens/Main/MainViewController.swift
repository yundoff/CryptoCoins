//
//  MainViewController.swift
//  CryptoCoins
//
//  Created by Aleksey Yundov on 13.01.2025.
//

import UIKit

protocol MainViewControllerProtocol: AnyObject {
    
    func display(_ initialData: Main.InitialData)
    func display(_ currencies: [Main.Currency])
    func display(_ error: Main.Error)
    
}

final class MainViewController: UIViewController {
    
    // MARK: - Nested Types
    
    enum Constants {
        
        static let bigFontSize: CGFloat = 24
    }
    
    // MARK: - Properties
    
    private let presenter: MainPresenterProtocol
    private var currencies: [Main.Currency] = []
    
    // MARK: - Views
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = label.font.withSize(Constants.bigFontSize)
        label.textColor = .white
        label.sizeToFit()
        
        return label
    }()
    
    private let searchButton = UIButton()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.refreshControl = refreshControl
        
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.id)
        
        return tableView
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        return searchController
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        return refreshControl
    }()
    
    // MARK: - Init
    
    init(presenter: MainPresenterProtocol) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupViews()
        
        presenter.requestInitialData()
        presenter.requestAssets()
    }
    
    // MARK: - Setup Views
    
    private func setupNavigationBar() {
        let rightItem = UIBarButtonItem(
            image: UIImage(resource: .search),
            style: .plain,
            target: self,
            action: #selector(searchButtonAction))
        navigationItem.rightBarButtonItem = rightItem
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .gray
        
        let leftItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.leftBarButtonItem = leftItem
        
        navigationItem.searchController = searchController
        
        navigationController?.navigationBar.barStyle = .black
    }
    
    private func setupViews() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    // MARK: - Actions
    
    @objc
    private func searchButtonAction() {
        navigationItem.searchController = searchController
        searchController.searchBar.becomeFirstResponder()
    }
    
    @objc
    private func refreshData(_ sender: UIRefreshControl) {
        guard !searchController.isActive else { return }
        
        presenter.requestAssets()
    }
    
    private func routeToDetailScreen(id: String, name: String) {
        let controller = DetailAssembly.assembly(id: id, name: name)
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - MainControllerProtocol

extension MainViewController: MainViewControllerProtocol {
    func display(_ initialData: Main.InitialData) {
        titleLabel.text = initialData.title
        searchButton.setImage(initialData.searchButtonImage, for: .normal)
        searchController.searchBar.placeholder = initialData.searchBarPlaceholder
        view.backgroundColor = UIColor(patternImage: initialData.backgroundImage)
    }
    
    func display(_ currencies: [Main.Currency]) {
        self.currencies = currencies
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func display(_ error: Main.Error) {
        let alert = UIAlertController(
            title: error.title,
            message: error.message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: error.buttonTitle, style: .default))
        
        present(alert, animated: true)
    }
}

// MARK: - UISearchResultsUpdating

extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        
        presenter.search(text: text)
    }
}

// MARK: - UITableViewDataSource

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        currencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.id, for: indexPath)
                as? MainTableViewCell
        else {
            return UITableViewCell()
        }
        
        let model = currencies[indexPath.row]
        cell.setup(model: model)
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension MainViewController: UITableViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchController.searchBar.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = currencies[indexPath.row]
        routeToDetailScreen(id: model.id, name: model.name)
    }
}
