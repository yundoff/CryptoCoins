//
//  MainViewController.swift
//  Test
//
//  Created by Aleksey Yundov on 13.01.2025.
//

import UIKit

class MainViewController: UIViewController, MainViewControllerProtocol {
    
    // MARK: - Properties
    private let presenter: MainPresenterProtocol
    private var currencyData: [Main.Response.Currency] = []
    private var filteredCurrencyData: [Main.Response.Currency] = []
    
    // MARK: - UI Properties
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Trending Coins"
        label.font = label.font.withSize(24)
        label.textColor = .white
        label.sizeToFit()
        return label
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "search"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.setTitleColor(.clear, for: .normal)
        button.backgroundColor = .clear
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.id)
        tableView.refreshControl = refreshControl
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: view.frame.height/4, right: 0)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search..."
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.obscuresBackgroundDuringPresentation = false
        return searchController
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        refreshControl.tintColor = .white
        return refreshControl
    }()

    // MARK: - Init
    init(presenter: MainPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTapToDismissSearch()
        setupNavigationBar()
        setupViews()
        setupLayout()
        presenter.requestCurrencyData()
    }

    
    // MARK: - MainControllerProtocol
    func display(models: [Main.Response.Currency]) {
        currencyData = models
        filteredCurrencyData = models
        tableView.reloadData()
        refreshControl.endRefreshing()
    }

    func displayError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - Private Methods
    private func setupViews() {
        view.addSubview(tableView)
        view.backgroundColor = UIColor(patternImage: UIImage(named: "background") ?? UIImage())
    }
    
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
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func setupTapToDismissSearch() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapToDismissSearch(_:)))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Actions
    @objc
    private func tapToDismissSearch(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: tableView)
        guard tableView.indexPathForRow(at: tapLocation) == nil else {
            return
        }
        searchController.searchBar.resignFirstResponder()
        searchController.searchBar.text = ""
        filteredCurrencyData = currencyData
        tableView.reloadData()
    }

    @objc
    private func searchButtonAction() {
        navigationItem.searchController = searchController
        searchController.searchBar.becomeFirstResponder()
    }
    @objc
    private func refreshData(_ sender: UIRefreshControl) {
        presenter.requestCurrencyData()
    }

}

// MARK: - Extensions
extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased(), !searchText.isEmpty else {
            filteredCurrencyData = currencyData
            tableView.reloadData()
            return
        }
        filteredCurrencyData = currencyData.filter { currency in
            currency.id.lowercased().contains(searchText) || currency.symbol.lowercased().contains(searchText)
        }
        tableView.reloadData()
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCurrencyData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.id, for: indexPath) as? MainTableViewCell else {
            return UITableViewCell()
        }
        let model = filteredCurrencyData[indexPath.row]
        cell.setup(model: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = filteredCurrencyData[indexPath.row]
        presenter.cellTapped(id: model.id)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchController.searchBar.resignFirstResponder()
    }
}
