//
//  CollectionViewTableViewCell.swift
//  NetflixClone
//
//  Created by developer on 6/6/22.
//

import UIKit

protocol CollectionViewTableViewCellDelegate: AnyObject {
    func CollectionViewTableViewCellDidTap(_ cell: CollectionViewTableViewCell, viewModel: VideoPrevViewModel)
}

class CollectionViewTableViewCell: UITableViewCell {
    
    
    weak var delegate: CollectionViewTableViewCellDelegate?
    
    typealias videoResult = Result<[Video], NetworkError>
    
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
    
    private func downloadMovie(index: IndexPath) {
        DataPresistenceManger.shared.downloadShow(with: shows[index.row]) {  result in
            switch result {
            case .success(()):
                NotificationCenter.default.post(name: NSNotification.Name("Downloaded"), object: nil)
            case.failure(let error):
                print(error)
            }
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let show = shows[indexPath.row]
        let title = show.title ?? show.name ?? ""
        let youtubeReq = YoutubeRequest()
        youtubeReq.getYoutubeResult(with: title) { [weak self] result in
            self?.handelResult(result: result, show: show)
        }
    }
    
    private func handelResult(result: videoResult, show: Titles) {
        switch result {
        case .success(let video):
            let viewModel = VideoPrevViewModel(title: show.title ?? show.name ?? "", youtubeView: video[0], showOverview: show.overview ?? "")
            self.delegate?.CollectionViewTableViewCellDidTap(self, viewModel: viewModel)
            print(video[0].id.videoId ?? "")
        case .failure(let error):
            print(error)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) {[weak self] _ in
            let downloadAction = UIAction(title: "Downlaod", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                self?.downloadMovie(index: indexPath)
            }
            return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
        }
        return config
    }
    
}
