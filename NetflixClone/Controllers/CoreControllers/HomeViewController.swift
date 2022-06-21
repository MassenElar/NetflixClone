//
//  HomeViewController.swift
//  NetflixClone
//
//  Created by developer on 6/6/22.
//

import UIKit


enum Sections: Int {
    case TrendingMovies = 0
    case TrendingTv = 1
    case Popular = 2
    case Upcoming = 3
    case TopRated = 4
}

class HomeViewController: UIViewController {
    
    typealias ShowResult = Result<[Titles], NetworkError>
    
    private var randomTrendingMovie: Titles?
    private var headerView: MainHeaderView?
    
    let sectionTitles: [String] = ["Trending Movies", "Popular", "Trending Tv", "Upcomming Movies", "Top Rated"]

    private let homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable)
        
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        // nav bar
        configureNavBar()
        
        // the tableView header
        configureMainHeaderView()
        headerView = MainHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        homeFeedTable.tableHeaderView = headerView
        
    }
    
    private func configureMainHeaderView() {
        let req = TrendingMoviesRequest()
        req.getTrendingMovies { [weak self] result in
            switch result{
            case .success(let shows):
                self?.randomTrendingMovie = shows.randomElement()
                guard let ikhan = self?.randomTrendingMovie else {
                    return
                }
                self?.headerView?.configure(with: ikhan)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func configureNavBar() {
        let logoBtn = UIButton(type: .custom)
        logoBtn.frame = CGRect(x: 0.0, y: 0.0, width: 20, height: 20)
        logoBtn.setImage(UIImage(named: "netflixLG"), for: .normal)
        let menuBarItem = UIBarButtonItem(customView: logoBtn)
        let currWidth = menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 20)
        currWidth?.isActive = true
        let currHeight = menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 35)
        currHeight?.isActive = true
        navigationItem.leftBarButtonItem = menuBarItem
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        navigationController?.navigationBar.tintColor = .white
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
    
    

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        switch indexPath.section {
            case Sections.TrendingMovies.rawValue:
                let trendingMoviesReq = TrendingMoviesRequest()
                trendingMoviesReq.getTrendingMovies { result in
                    switch result{
                    case .success(let titles):
                        cell.configure(with: titles)
                    case .failure(let error):
                        print(error)
                    }
                }
            case Sections.TrendingTv.rawValue:
                let trendingTvReq = TrendingTvsRequest()
                trendingTvReq.getTrendingTvs { result in
                    switch result{
                    case .success(let titles):
                        cell.configure(with: titles)
                    case .failure(let error):
                        print(error)
                    }
                }
            case Sections.Popular.rawValue:
                let popularReq = PopularRequest()
                popularReq.getPopularMovie { result in
                    switch result{
                    case .success(let titles):
                        cell.configure(with: titles)
                    case .failure(let error):
                        print(error)
                    }
                }
            
            case Sections.Upcoming.rawValue:
                let upcomingReq = UpcomingRequest()
                upcomingReq.getUpcomingMovie { result in
                    switch result{
                    case .success(let titles):
                        cell.configure(with: titles)
                    case .failure(let error):
                        print(error)
                    }
                }
            case Sections.TopRated.rawValue:
                let topRatedReq = TopRatedRequest()
                topRatedReq.getTopRatedMovie { result in
                    switch result{
                    case .success(let titles):
                        cell.configure(with: titles)
                    case .failure(let error):
                        print(error)
                    }
                }
            
        default:
            return UITableViewCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {
            return
        }
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
//        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .white
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        header.textLabel?.text = header.textLabel?.text?.capitalized
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
    
}


extension HomeViewController: CollectionViewTableViewCellDelegate {
    func CollectionViewTableViewCellDidTap(_ cell: CollectionViewTableViewCell, viewModel: VideoPrevViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = ShowPrevViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}
