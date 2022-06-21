//
//  ShowTableViewCell.swift
//  NetflixClone
//
//  Created by developer on 6/15/22.
//

import UIKit

class ShowTableViewCell: UITableViewCell {

    static let identifier = "ShowTableViewCell"
    
    
    private let playButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40))
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        return button
    }()
    
    private let showLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private let posterImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(posterImage)
        contentView.addSubview(showLabel)
        contentView.addSubview(playButton)
        
        applyConstraints()
    }
    
    
    private func applyConstraints() {
        let posterImageConstraints = [
            posterImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            posterImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            posterImage.widthAnchor.constraint(equalToConstant: 100)
        ]
        
        let showLabelConstraints = [
            showLabel.leadingAnchor.constraint(equalTo: posterImage.trailingAnchor, constant: 20),
            showLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            showLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -60)
        ]
        
        let playButtonConstraints = [
            playButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            playButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor )
        ]

        NSLayoutConstraint.activate(posterImageConstraints)
        NSLayoutConstraint.activate(showLabelConstraints)
        NSLayoutConstraint.activate(playButtonConstraints)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    
    
    public func updateUi(show: ShowViewModel) {
        
        
        let imageLink = show.poster
        DispatchQueue.main.async { [weak self] in
            self?.showLabel.text = show.title
        }
        self.getImage(str: "https://image.tmdb.org/t/p/w500\(imageLink)")
    }
    
    
    private func getImage(str: String?) {
        if let imageStr = str {
            ImageCache.shared.loadImage(from: imageStr) { image in
                DispatchQueue.main.async {
                    self.posterImage.image = image
                }
            }
        }
    }

}
