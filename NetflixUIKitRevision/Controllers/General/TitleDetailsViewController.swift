//
//  TitleDetailsViewController.swift
//  NetflixUIKitRevision
//
//  Created by Ujjwal Arora on 22/02/25.
//

import UIKit
import WebKit

class TitleDetailsViewController: UIViewController {
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Harry Potter"
        return label
    }()
    
    private let descriptionLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Best movie for kids"
        return label
    }()
    
    private let downloadButton : UIButton = {
        let button = UIButton()
        button.setTitle("Downloads", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .red
        
        button.layer.cornerRadius = 8 // Makes the button rounded
        button.layer.masksToBounds = true // Ensures content stays within the rounded corners
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let webView : WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(webView)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(downloadButton)
        
        applyConstraints()
    }
    private func applyConstraints(){
        let webViewConstraints = [
            webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/3)
        ]
        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor ,constant: 20),
        ]
        let descriptionLabelConstraints = [
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor ,constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor ,constant: -20),
        ]
        let downloadButtonConstraints = [
            downloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            downloadButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor ,constant: 20),
            downloadButton.widthAnchor.constraint(equalToConstant: 150),
            downloadButton.heightAnchor.constraint(equalToConstant: 40)
        ]
        NSLayoutConstraint.activate(webViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(descriptionLabelConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraints)
    }
    func configure(model : TitleDetailsViewModel){
        titleLabel.text = model.title
        descriptionLabel.text = model.description
        
        guard let url = URL(string: "https://www.youtube.com/embed/\(model.youtubeVideoId)") else { return}
        webView.load(URLRequest(url: url))
    }
}
#Preview{
    TitleDetailsViewController()
}
