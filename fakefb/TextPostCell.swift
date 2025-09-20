//
//  TextPostCell.swift
//  fakefb
//
//  Created by Claude on 19/09/2025.
//

import UIKit

class TextPostCell: UITableViewCell {
    static let identifier = "TextPostCell"
    
    private let containerView = UIView()
    private let profileImageView = UIImageView()
    private let usernameLabel = UILabel()
    private let timestampLabel = UILabel()
    private let contentLabel = UILabel()
    private let engagementStackView = UIStackView()
    private let likeButton = UIButton()
    private let commentButton = UIButton()
    private let shareButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.0)
        
        containerView.backgroundColor = .white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        
        profileImageView.backgroundColor = .systemGray4
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(profileImageView)
        
        usernameLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        usernameLabel.textColor = UIColor(red: 0.23, green: 0.35, blue: 0.60, alpha: 1.0)
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(usernameLabel)
        
        timestampLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        timestampLabel.textColor = .systemGray
        timestampLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(timestampLabel)
        
        contentLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        contentLabel.textColor = .black
        contentLabel.numberOfLines = 0
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(contentLabel)
        
        setupEngagementButtons()
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            profileImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            profileImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            profileImageView.widthAnchor.constraint(equalToConstant: 40),
            profileImageView.heightAnchor.constraint(equalToConstant: 40),
            
            usernameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            usernameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 12),
            usernameLabel.trailingAnchor.constraint(lessThanOrEqualTo: timestampLabel.leadingAnchor, constant: -8),
            
            timestampLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 2),
            timestampLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 12),
            
            contentLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 12),
            contentLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            contentLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            
            engagementStackView.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 12),
            engagementStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            engagementStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            engagementStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            engagementStackView.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    private func setupEngagementButtons() {
        engagementStackView.axis = .horizontal
        engagementStackView.distribution = .fillEqually
        engagementStackView.spacing = 0
        engagementStackView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(engagementStackView)
        
        likeButton.setTitle("Like", for: .normal)
        likeButton.setTitleColor(.systemGray, for: .normal)
        likeButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        
        commentButton.setTitle("Comment", for: .normal)
        commentButton.setTitleColor(.systemGray, for: .normal)
        commentButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        commentButton.addTarget(self, action: #selector(commentButtonTapped), for: .touchUpInside)
        
        shareButton.setTitle("Share", for: .normal)
        shareButton.setTitleColor(.systemGray, for: .normal)
        shareButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        
        engagementStackView.addArrangedSubview(likeButton)
        engagementStackView.addArrangedSubview(commentButton)
        engagementStackView.addArrangedSubview(shareButton)
        
        let separator1 = UIView()
        separator1.backgroundColor = UIColor.systemGray5
        separator1.translatesAutoresizingMaskIntoConstraints = false
        
        let separator2 = UIView()
        separator2.backgroundColor = UIColor.systemGray5
        separator2.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(separator1)
        containerView.addSubview(separator2)
        
        NSLayoutConstraint.activate([
            separator1.topAnchor.constraint(equalTo: engagementStackView.topAnchor),
            separator1.bottomAnchor.constraint(equalTo: engagementStackView.bottomAnchor),
            separator1.leadingAnchor.constraint(equalTo: commentButton.leadingAnchor),
            separator1.widthAnchor.constraint(equalToConstant: 1),
            
            separator2.topAnchor.constraint(equalTo: engagementStackView.topAnchor),
            separator2.bottomAnchor.constraint(equalTo: engagementStackView.bottomAnchor),
            separator2.leadingAnchor.constraint(equalTo: shareButton.leadingAnchor),
            separator2.widthAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    @objc private func likeButtonTapped() {
        
    }
    
    @objc private func commentButtonTapped() {
        
    }
    
    @objc private func shareButtonTapped() {
        
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
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        usernameLabel.text = nil
        timestampLabel.text = nil
        contentLabel.text = nil
        profileImageView.image = nil
        profileImageView.backgroundColor = .systemGray4
    }
}