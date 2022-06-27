//
//  MainHeaderView.swift
//  NetflixClone
//
//  Created by developer on 6/6/22.
//

import UIKit

class MainHeaderView: UIView {
    
    
    private let playButton: UIButton = {
        let button = UIButton()
        button.setTitle("Play", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        return button
        
    }()
    
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        return button
        
    }()
    
    
    
    
    
    private let MainHeaderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private func addGradient() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.clear.cgColor, UIColor.systemBackground.cgColor]
        gradient.frame = bounds
        layer.addSublayer(gradient)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        addSubview(MainHeaderImageView)
        addGradient()
        addSubview(playButton)
        addSubview(downloadButton)
        applyButtonConstraints()
    }
    
    
    private func applyButtonConstraints() {
        let playButtonConstraint = [
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 90),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            playButton.widthAnchor.constraint(equalToConstant: 110)
        ]
        
        let downButtonConstraint = [
            downloadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -90),
            downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            downloadButton.widthAnchor.constraint(equalToConstant: 110)
        ]
        NSLayoutConstraint.activate(playButtonConstraint)
        NSLayoutConstraint.activate(downButtonConstraint)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        MainHeaderImageView.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    public func configure(with show: Titles) {
        guard let imageLink = show.poster else {
            return
        }
        self.getImage(str: "https://image.tmdb.org/t/p/w500\(imageLink)")
    }
    
    private func getImage(str: String?) {
        if let imageStr = str {
            ImageCache.shared.loadImage(from: imageStr) { image in
                DispatchQueue.main.async {
                    self.MainHeaderImageView.image = image
                }
            }
        }
    }

}
