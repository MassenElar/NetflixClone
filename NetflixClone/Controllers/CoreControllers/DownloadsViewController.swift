//
//  DownloadsViewController.swift
//  NetflixClone
//
//  Created by developer on 6/6/22.
//

import UIKit

protocol ShowData { }

extension Titles: ShowData { }
extension ShowItem: ShowData { }

class DownloadsViewController: UIViewController {
    
    
    var titles: [ShowItem] =  [] {
        didSet {
            DispatchQueue.main.async {
                self.downloadsTable.reloadData()
            }
        }
    }
    
    
    private let downloadsTable: UITableView = {
        let table = UITableView()
        table.register(ShowTableViewCell.self, forCellReuseIdentifier: ShowTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Downloads"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        // tabel view setup
        view.addSubview(downloadsTable)
//        tableViewConstraints()
        downloadsTable.delegate = self
        downloadsTable.dataSource = self
        
        // fetching data
        fetchDownloads()
        
        // lisening for changes
        NotificationCenter.default.addObserver(forName: NSNotification.Name("Downloaded"), object: nil, queue: nil) { _ in
            self.fetchDownloads()
        }
        
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        downloadsTable.frame = view.bounds
    }
   
    private func fetchDownloads() {
        DataPresistenceManger.shared.fetchData { [weak self] result in
            switch result {
            case .success(let shows):
                self?.titles = shows
            case .failure(let error):
                print(error)
            }
        }
    }

}

extension DownloadsViewController: UITableViewDelegate, UITableViewDataSource {
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            DataPresistenceManger.shared.deletingItem(with: titles[indexPath.row]) { [weak self] result in
                switch result {
                case .success(()):
                    print("Item Deleted")
                case .failure(let error):
                    print(error.localizedDescription)
                }
                self?.titles.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        default:
            break;
        }
    }
    
}
