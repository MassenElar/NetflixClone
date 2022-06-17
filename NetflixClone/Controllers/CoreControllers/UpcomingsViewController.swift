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
        view.backgroundColor = .systemBackground
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
        upcomingReq.getUpcomingMovie { result in
            self.handelResult(result: result)
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
        cell.updateUi(show: titles[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
