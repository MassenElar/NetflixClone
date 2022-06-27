//
//  UpcomingsViewController.swift
//  NetflixClone
//
//  Created by developer on 6/6/22.
//

import UIKit

class UpcomingsViewController: UIViewController {
    
    
    typealias upcomingResult = Result<[Titles], NetworkError>
    
    var titles: [Titles] =  [] {
        didSet {
            DispatchQueue.main.sync {
                self.upcomingTable.reloadData()
            }
        }
    }
    
    private let upcomingTable: UITableView = {
        let table = UITableView()
        table.register(ShowTableViewCell.self, forCellReuseIdentifier: ShowTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        // fetching data
        fetchUpcoming()
        // tabel view setup
        view.addSubview(upcomingTable)
//        tableViewConstraints()
        upcomingTable.delegate = self
        upcomingTable.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upcomingTable.frame = view.bounds
    }
    
    private func fetchUpcoming() {
        let upcomingReq = UpcomingRequest()
        upcomingReq.getUpcomingMovie { [weak self] result in
            self?.handelResult(result: result)
        }
    }
    
    private func handelResult(result: upcomingResult) {
        switch result{
        case .success(let titles):
            self.titles = titles
        case .failure(let error):
            print(error)
        }
    }
    
    private func tableViewConstraints() {
        let upcomingTableConstraints = [
            upcomingTable.topAnchor.constraint(equalTo: view.topAnchor, constant: 50)
        ]
        NSLayoutConstraint.activate(upcomingTableConstraints)
    }
    
}

extension UpcomingsViewController: UITableViewDelegate, UITableViewDataSource {
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
                showDetials.handleResult(result: result, show: model, viewController: self ?? UpcomingsViewController())
            }
//            showDetials.getShowDetails(with: ShowViewModel(title: show?.name ?? "" , poster: show?.poster ?? "", overView: show?.overview ?? ""), viewController: self ?? UpcomingsViewController())
        }
        
    }
}

