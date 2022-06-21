//
//  ShowPrevViewController.swift
//  NetflixClone
//
//  Created by developer on 6/17/22.
//

import UIKit
import WebKit

class ShowPrevViewController: UISearchController {
    
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.text = "Ikhan"
        return label
    }()
    
    private let overflowLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        label.text = "l9lawi zeb ara ikhan"
        return label
    }()
    
    
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        button.setTitle("Download", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 7
        button.layer.masksToBounds = true
        return button
    }()
    
    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(webView)
        view.addSubview(titleLabel)
        view.addSubview(overflowLabel)
        view.addSubview(downloadButton)
        
        configureConstraints()
    }
    
    private func configureConstraints() {
        let webViewConstraints = [
            webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.heightAnchor.constraint(equalToConstant: 250)
        ]
        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        ]
        let overFlowConstraints = [
            overflowLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            overflowLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            overflowLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ]
        let downloadButtonConstraints = [
            downloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            downloadButton.topAnchor.constraint(equalTo: overflowLabel.bottomAnchor, constant: 40),
            downloadButton.widthAnchor.constraint(equalToConstant: 120),
            downloadButton.heightAnchor.constraint(equalToConstant: 35)
        ]
        
        NSLayoutConstraint.activate(webViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(overFlowConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraints)
    }
    
    func configure(with model: VideoPrevViewModel) {
        titleLabel.text = model.title
        overflowLabel.text = model.showOverview
        let webConfig = WKWebViewConfiguration()
        webConfig.allowsInlineMediaPlayback = true
        
        guard let videoId = model.youtubeView.id.videoId else {
            return
        }
        
        guard let url = URL(string: "https://www.youtube.com/embed/\(videoId)") else {
            return
        }
        let req = URLRequest(url: url)
        
        webView.load(req)
        
    }

}
