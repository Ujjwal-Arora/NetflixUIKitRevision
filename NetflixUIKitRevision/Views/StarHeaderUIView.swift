//
//  StarHeaderUIView.swift
//  NetflixUIKitRevision
//
//  Created by Ujjwal Arora on 16/02/25.
//

import UIKit
/*
 When you directly write addSubview() inside a UIView subclass, the subview is added to self, which is the UIView instance itself.

 Where is addSubview() adding the view?
     •    If inside a UIView subclass, it adds to the UIView itself.
     •    If inside a UIViewController, it adds to self.view.
     •    If inside a UITableViewCell or UICollectionViewCell, it’s best to add to contentView, not self.
 */
class StarHeaderUIView: UIView {

    private let starImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "tree")
        return imageView
        
    }()
    
    private let playButton : UIButton = {
        let button = UIButton()
        button.setTitle("Play", for: .normal)
        button.layer.borderColor = UIColor.label.cgColor
        button.setTitleColor(.label, for: .normal)
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let downloadButton : UIButton = {
        let button = UIButton()
        button.setTitle( "Download", for: .normal)
        button.layer.borderColor = UIColor.label.cgColor
        button.layer.cornerRadius = 5
        button.setTitleColor(.label, for: .normal)
        button.layer.borderWidth = 2
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private func addGradient(){
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.clear.cgColor, UIColor.systemBackground.cgColor]
        gradient.frame = bounds
        layer.addSublayer(gradient)
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(starImageView)
    }
    required init?(coder: NSCoder) {
        fatalError( "init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        starImageView.frame = bounds
        addGradient()
        addSubview(playButton)
        addSubview(downloadButton)
        applyConstraints()

   }
    private func applyConstraints(){
        let playButtonConstraints = [
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 100),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            playButton.widthAnchor.constraint(equalToConstant: 75)
        ]
        let downloadButtonConstraints = [
            downloadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -75),
            downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            downloadButton.widthAnchor.constraint(equalToConstant: 100)
        ]
        NSLayoutConstraint.activate(playButtonConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraints)
        
    }
}
#Preview{
    StarHeaderUIView()
}
/*
 so uiview has self, uiviewcontroller has view, uitableviewcell/uicollectionviewcell has contentView
 
 The contentView property exists only in UITableViewCell and UICollectionViewCell.

 Where contentView Exists:
     1.    UITableViewCell
     •    Every UITableViewCell has a contentView, which is where you should add subviews.
     •    Example:
 class CustomTableViewCell: UITableViewCell {
     private let label = UILabel()
     
     override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
         super.init(style: style, reuseIdentifier: reuseIdentifier)
         contentView.addSubview(label) // ✅ Add views to contentView
     }
     
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
 }
 2.    UICollectionViewCell
 •    Works similarly to UITableViewCell, and subviews should be added to contentView.
 class CustomCollectionViewCell: UICollectionViewCell {
     private let imageView = UIImageView()
     
     override init(frame: CGRect) {
         super.init(frame: frame)
         contentView.addSubview(imageView) // ✅ Add views to contentView
     }
     
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
 }
 Where contentView Does NOT Exist:
     •    UIView (like your StarHeaderUIView)
     •    Regular UIViews don’t have contentView, so you directly use addSubview().
     •    Example:
 class CustomView: UIView {
     private let button = UIButton()
     
     override init(frame: CGRect) {
         super.init(frame: frame)
         addSubview(button) // ✅ Directly adding to self
     }
     
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
 }
 •    UIViewController
 •    The main view of a UIViewController is self.view, not contentView.
 •    Example:
 class CustomViewController: UIViewController {
     private let label = UILabel()
     
     override func viewDidLoad() {
         super.viewDidLoad()
         view.addSubview(label) // ✅ Adding to view, not contentView
     }
 }
 
 */
