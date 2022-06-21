//
//  SearchResultViewController.swift
//  NetflixClone
//
//  Created by developer on 6/16/22.
//

import UIKit

protocol SearchResultsViewControllerDelagate: AnyObject {
    func searchResultsViewControllerDidTaped(_ viewModel: VideoPrevViewModel)
}

class SearchResultViewController: UIViewController {
    
    public weak var delagate: SearchResultsViewControllerDelagate?
    
    public var titles: [Titles] = [] {
        didSet {
            DispatchQueue.main.async {
                self.searchCollectionView.reloadData()
            }
        }
    }
    
    public let searchCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        layout.minimumInteritemSpacing = 0
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(ShowCollectionViewCell.self, forCellWithReuseIdentifier: ShowCollectionViewCell.identifier)
        return collection
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(searchCollectionView)
        
        searchCollectionView.delegate = self
        searchCollectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchCollectionView.frame = view.bounds
    }
    

}

extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShowCollectionViewCell.identifier, for: indexPath) as? ShowCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(model: titles[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let show = titles[indexPath.row]
        
        let title = show.title ?? show.name ?? ""
        let ytbReq = YoutubeRequest()
        ytbReq.getYoutubeResult(with: title) { [weak self] result in
            switch result {
            case .success(let video):
                DispatchQueue.main.async {
                    self?.delagate?.searchResultsViewControllerDidTaped(VideoPrevViewModel(title: title, youtubeView: video[0], showOverview: show.overview ?? ""))
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
}
