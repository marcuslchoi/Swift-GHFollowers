//
//  GHFollowerCell.swift
//  GHFollowers
//
//  Created by Marcus Choi on 1/15/22.
//

import UIKit

class GHFollowerCell: UICollectionViewCell {
    static let reuseId = "followerCell"
    let avatarImageView = GHAvatarImageView(frame: .zero)
    let usernameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setFollower(follower: Follower) {
        usernameLabel.text = follower.login
        avatarImageView.downloadImage(from: follower.avatarUrl)
    }
    
    func configure()
    {
        addSubview(avatarImageView)
        addSubview(usernameLabel)
        usernameLabel.textAlignment = .center
//        let img = UIImage(named: "avatar-placeholder")?.resizeImage(20.0, opaque: true)
//        avatarImageView.image = img!
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        let padding: CGFloat = 8
        
        let constraints = [
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            avatarImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            //this line was needed to make sure images are all the same size
            avatarImageView.widthAnchor.constraint(equalToConstant: 100),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            
            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12),
            usernameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            usernameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            usernameLabel.heightAnchor.constraint(equalToConstant: 20)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
