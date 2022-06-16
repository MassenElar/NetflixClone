//
//  CollectionViewTableViewCell.swift
//  NetflixClone
//
//  Created by developer on 6/6/22.
//

import UIKit

class CollectionViewTableViewCell: UITableViewCell {
    
    
    
    
    private var shows: [Titles] = [Titles]()
    
    static let identifier = "CollectionViewTableViewCell"
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ShowCollectionViewCell.self, forCellWithReuseIdentifier: ShowCollectionViewCell.identifier)
        return collectionView
    }()
    
    
//    var TrendMovies: [Movie] = [] {
//        didSet {
//            DispatchQueue.main.async {
//                self.collectionView.reloadData()
//            }
//        }
//    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemPink
        contentView.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    
    // updating data using api calls
    
//    private func getTrendingMovies() {
//        let trendingMoviesRequest = TrendingMoviesRequest()
//        trendingMoviesRequest.getTrendingMovies { result in
//            self.handleResult(result: result)
//        }
//    }
//    
//    func handleResult(result: TrendingMovies) {
//        switch result {
//        case .failure(let error):
//            print(error)
//        case .success(let movies):
//            self.TrendMovies = movies
//        }
//    }
    
    public func configure(with titles: [Titles]) {
        self.shows = titles
        DispatchQueue.main.sync { [weak self] in
            self?.collectionView.reloadData()
        }
    }

}

extension CollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shows.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShowCollectionViewCell.identifier, for: indexPath) as? ShowCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let model = shows[indexPath.row]
        print(shows[indexPath.row].poster ?? "")
        cell.configure(model: model)
        return cell
    }
    
    
}
