//
//  ImagePostCell.swift
//  fakefb
//
//  Created by Claude on 19/09/2025.
//

import UIKit

class ImagePostCell: UITableViewCell {
    static let identifier = "ImagePostCell"
    
    private let containerView = UIView()
    private let profileImageView = UIImageView()
    private let usernameLabel = UILabel()
    private let timestampLabel = UILabel()
    private let contentLabel = UILabel()
    private let postImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .systemBackground
        
        containerView.backgroundColor = .systemBackground
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        
        profileImageView.backgroundColor = .systemGray4
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(profileImageView)
        
        usernameLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        usernameLabel.textColor = .label
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(usernameLabel)
        
        timestampLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        timestampLabel.textColor = .secondaryLabel
        timestampLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(timestampLabel)
        
        contentLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        contentLabel.textColor = .label
        contentLabel.numberOfLines = 0
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(contentLabel)
        
        postImageView.contentMode = .scaleAspectFill
        postImageView.clipsToBounds = true
        postImageView.backgroundColor = .systemGray5
        postImageView.layer.cornerRadius = 8
        postImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(postImageView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            profileImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            profileImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            profileImageView.widthAnchor.constraint(equalToConstant: 40),
            profileImageView.heightAnchor.constraint(equalToConstant: 40),
            
            usernameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            usernameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 12),
            usernameLabel.trailingAnchor.constraint(lessThanOrEqualTo: timestampLabel.leadingAnchor, constant: -8),
            
            timestampLabel.centerYAnchor.constraint(equalTo: usernameLabel.centerYAnchor),
            timestampLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            
            contentLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 12),
            contentLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            contentLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            
            postImageView.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 12),
            postImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            postImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            postImageView.heightAnchor.constraint(equalToConstant: 250),
            postImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12)
        ])
        
        containerView.layer.borderWidth = 0.5
        containerView.layer.borderColor = UIColor.separator.cgColor
        containerView.layer.cornerRadius = 8
    }
    
    func configure(with post: PostModel) {
        usernameLabel.text = post.username
        timestampLabel.text = post.timeAgo
        contentLabel.text = post.content
        
        if let profileImage = post.profileImage {
            profileImageView.image = profileImage
        } else {
            profileImageView.backgroundColor = .systemGray4
        }
        
        if let postImage = post.image {
            postImageView.image = postImage
        } else {
            postImageView.backgroundColor = .systemGray5
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        usernameLabel.text = nil
        timestampLabel.text = nil
        contentLabel.text = nil
        profileImageView.image = nil
        profileImageView.backgroundColor = .systemGray4
        postImageView.image = nil
        postImageView.backgroundColor = .systemGray5
    }
}