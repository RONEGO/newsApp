//
//  ViewController.swift
//  goraNews
//
//  Created by Yegor Geronin on 12.03.2022.
//

import UIKit
import SafariServices

class mainViewController: mainViewDelegate {
    
    var cells = [categoryStruct]()
    
    public var isMainView: Bool = true
    
    private let tableView: UITableView =  {
        let table = UITableView()
        table.separatorStyle                = .none
        table.allowsSelection               = false
        table.showsVerticalScrollIndicator  = false
        table.register(cellCustomScroll.self, forCellReuseIdentifier: "customCell")
        return table
    }()
    
    public let spinner = UIActivityIndicatorView(style: .large)
    
    public var mainPresenter: mainViewPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rsVC = resultViewController()
        rsVC.isMainView = false
        navigationItem.searchController = UISearchController(searchResultsController: rsVC)
        navigationItem.searchController?.searchResultsUpdater = self
        
        spinner.startAnimating()
        
        mainPresenter = mainViewPresenter(self)
        if isMainView {
            mainPresenter?.fetchNews()
        }
        
        tableView.delegate      = self
        tableView.dataSource    = self
        
        view.addSubview(tableView)
        view.addSubview(spinner)
    }
    
    override func viewWillLayoutSubviews() {
        tableView.frame = view.bounds
        spinner.frame   = view.bounds
    }
}

// MARK: - work with table

extension mainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func reloadTable(with articles: [categoryStruct]) {
        spinner.stopAnimating()
        
        cells = articles.sorted { $0.title < $1.title }
        
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .heightHeader
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return .heightScroll
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = cellHeaderView(frame: CGRect(x: 0,
                                                y: 0,
                                                width: tableView.width,
                                                height: .heightHeader),
                                  title: cells[section].title)
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as? cellCustomScroll else {
            return UITableViewCell()
        }
        cell.setArticles(with: cells[indexPath.section].news, mainView: self)
        return cell
    }
}

// MARK: - open safari tab
extension mainViewController {
    public func openSafariPage(with url: String) {
        guard let url = URL(string: url) else {
            print("Invalid url :(")
            return
        }
        let svc = SFSafariViewController(url: url)
        svc.modalPresentationStyle = .formSheet
        present(svc, animated: true, completion: nil)
    }
}

// MARK: - search bar
extension mainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text,
              let vc = searchController.searchResultsController as? resultViewController else {
            return
        }
        vc.search(articleContains: text)
    }
}
