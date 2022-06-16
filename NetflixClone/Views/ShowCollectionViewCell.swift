//
//  ShowCollectionViewCell.swift
//  NetflixClone
//
//  Created by developer on 6/13/22.
//

import UIKit

class ShowCollectionViewCell: UICollectionViewCell {
    
    
    static let identifier = "ShowCollectionViewCell"
    
    
    
    private let posterImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.frame = contentView.bounds
    }
    
    
    public func configure(model: Titles) {
        
        guard let imageLink = model.poster else {
            return
        }
        self.getImage(str: "https://image.tmdb.org/t/p/w500\(imageLink)")
    }
    
    private func getImage(str: String?) {
        if let imageStr = str {
            ImageCache.shared.loadImage(from: imageStr) { image in
                DispatchQueue.main.async {
                    self.posterImageView.image = image
                }
            }
        }
    }
}
