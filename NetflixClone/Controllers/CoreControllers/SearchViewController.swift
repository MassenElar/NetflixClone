//
//  SearchViewController.swift
//  NetflixClone
//
//  Created by developer on 6/6/22.
//

import UIKit

class SearchViewController: UIViewController {
    
    typealias DiscoverResult = Result<[Titles], NetworkError>
    
    private var titles: [Titles] = [] {
        didSet {
            DispatchQueue.main.async {
                self.searchTable.reloadData()
            }
        }
    }
    
    private let searchTable: UITableView = {
        let table = UITableView()
        table.register(ShowTableViewCell.self, forCellReuseIdentifier: ShowTableViewCell.identifier)
        return table
    }()
    
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultViewController())
        controller.searchBar.placeholder = "Search for a Show"
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        fetchDiscoverMovies()
        
        view.addSubview(searchTable)
        searchTable.delegate = self
        searchTable.dataSource = self
        
        // search controller
        navigationController?.navigationBar.tintColor = .white
        navigationItem.searchController = searchController
        
        searchController.searchResultsUpdater = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchTable.frame = view.bounds
    }
    
    private func fetchDiscoverMovies() {
        let discReq = DiscoverRequest()
        discReq.getDiscover { [weak self] result in
            self?.handelResult(result: result)
        }
    }
    
    private func handelResult(result: DiscoverResult) {
        switch result{
        case .success(let titles):
            self.titles = titles
        case .failure(let error):
            print(error)
        }
    }
    

    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ShowTableViewCell.identifier, for: indexPath) as? ShowTableViewCell else {
            return UITableViewCell()
        }
        let show = titles[indexPath.row]
        cell.updateUi(show: ShowViewModel(title: show.title ?? "", poster: show.poster ?? "", overView: show.overview ?? ""))
        return cell 
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        DispatchQueue.main.async { [weak self] in
            let show = self?.titles[indexPath.row]
            let showDetials = ShowDetails()
            let ytbReq = YoutubeRequest()
            let model = ShowViewModel(title: show?.title ?? "", poster: show?.poster ?? "", overView: show?.overview ?? "")
            ytbReq.getYoutubeResult(with: show?.title ?? show?.name ?? "") { [weak self] result in
                showDetials.handleResult(result: result, show: model, viewController: self ?? SearchViewController())
            }
//            showDetials.getShowDetails(with: ShowViewModel(title: show?.name ?? "" , poster: show?.poster ?? "", overView: show?.overview ?? ""), viewController: self ?? UpcomingsViewController())
        }
    }
    
    
}


extension SearchViewController: UISearchResultsUpdating, SearchResultsViewControllerDelagate {
    
    func searchResultsViewControllerDidTaped(_ viewModel: VideoPrevViewModel) {
        let vc = ShowPrevViewController()
        vc.configure(with: viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultController = searchController.searchResultsController as? SearchResultViewController else {
                return
            }
        resultController.delagate = self
        let searchReq = SearchRequest()
        searchReq.getSearchResult(with: query) { result in
            switch result {
            case .success(let titles):
                resultController.titles = titles
            case .failure(let error):
                print(error)
            }
        }
    }
}

// done with search 
