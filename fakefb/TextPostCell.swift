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
    private let statsView = UIView()
    private let likesLabel = UILabel()
    private let commentsLabel = UILabel()
    private let sharesLabel = UILabel()
    private let engagementStackView = UIStackView()
    private let likeButton = UIButton()
    private let commentButton = UIButton()
    private let shareButton = UIButton()
    
    // Comments section
    private let commentsContainerView = UIView()
    private let commentsStackView = UIStackView()
    private var showComments = false
    private var currentPost: PostModel?
    
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
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1.0).cgColor // Gray-200
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        
        profileImageView.backgroundColor = .systemGray4
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(profileImageView)
        
        usernameLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        usernameLabel.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0) // Darker text for better visibility
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
        
        setupStatsView()
        setupEngagementButtons()
        setupCommentsSection()
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -1),
            
            profileImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            profileImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            profileImageView.widthAnchor.constraint(equalToConstant: 40),
            profileImageView.heightAnchor.constraint(equalToConstant: 40),
            
            usernameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            usernameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8),
            usernameLabel.trailingAnchor.constraint(lessThanOrEqualTo: timestampLabel.leadingAnchor, constant: -8),
            
            timestampLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 2),
            timestampLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8),
            
            contentLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 12),
            contentLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            contentLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            statsView.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 12),
            statsView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            statsView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            statsView.heightAnchor.constraint(equalToConstant: 24),
            
            engagementStackView.topAnchor.constraint(equalTo: statsView.bottomAnchor, constant: 8),
            engagementStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            engagementStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            engagementStackView.heightAnchor.constraint(equalToConstant: 40),
            
            commentsContainerView.topAnchor.constraint(equalTo: engagementStackView.bottomAnchor),
            commentsContainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            commentsContainerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            commentsContainerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    private func setupStatsView() {
        statsView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(statsView)
        
        // Like icon and count
        let likeIcon = UIImageView()
        likeIcon.image = UIImage(systemName: "heart.fill")
        likeIcon.tintColor = UIColor(red: 0.26, green: 0.40, blue: 0.70, alpha: 1.0)
        likeIcon.translatesAutoresizingMaskIntoConstraints = false
        
        likesLabel.font = UIFont.systemFont(ofSize: 13)
        likesLabel.textColor = .systemGray
        likesLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Comments and shares
        commentsLabel.font = UIFont.systemFont(ofSize: 13)
        commentsLabel.textColor = .systemGray
        commentsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        sharesLabel.font = UIFont.systemFont(ofSize: 13)
        sharesLabel.textColor = .systemGray
        sharesLabel.translatesAutoresizingMaskIntoConstraints = false
        
        statsView.addSubview(likeIcon)
        statsView.addSubview(likesLabel)
        statsView.addSubview(commentsLabel)
        statsView.addSubview(sharesLabel)
        
        NSLayoutConstraint.activate([
            likeIcon.leadingAnchor.constraint(equalTo: statsView.leadingAnchor),
            likeIcon.centerYAnchor.constraint(equalTo: statsView.centerYAnchor),
            likeIcon.widthAnchor.constraint(equalToConstant: 16),
            likeIcon.heightAnchor.constraint(equalToConstant: 16),
            
            likesLabel.leadingAnchor.constraint(equalTo: likeIcon.trailingAnchor, constant: 4),
            likesLabel.centerYAnchor.constraint(equalTo: statsView.centerYAnchor),
            
            commentsLabel.centerXAnchor.constraint(equalTo: statsView.centerXAnchor),
            commentsLabel.centerYAnchor.constraint(equalTo: statsView.centerYAnchor),
            
            sharesLabel.trailingAnchor.constraint(equalTo: statsView.trailingAnchor),
            sharesLabel.centerYAnchor.constraint(equalTo: statsView.centerYAnchor)
        ])
        
        // Add border
        let borderView = UIView()
        borderView.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        borderView.translatesAutoresizingMaskIntoConstraints = false
        statsView.addSubview(borderView)
        
        NSLayoutConstraint.activate([
            borderView.bottomAnchor.constraint(equalTo: statsView.bottomAnchor),
            borderView.leadingAnchor.constraint(equalTo: statsView.leadingAnchor),
            borderView.trailingAnchor.constraint(equalTo: statsView.trailingAnchor),
            borderView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    private func setupEngagementButtons() {
        engagementStackView.axis = .horizontal
        engagementStackView.distribution = .fillEqually
        engagementStackView.spacing = 0
        engagementStackView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(engagementStackView)
        
        setupButton(likeButton, title: "Páči sa mi", iconName: "heart", action: #selector(likeButtonTapped))
        setupButton(commentButton, title: "Komentovať", iconName: "message", action: #selector(commentButtonTapped))
        setupButton(shareButton, title: "Zdieľať", iconName: "square.and.arrow.up", action: #selector(shareButtonTapped))
        
        engagementStackView.addArrangedSubview(likeButton)
        engagementStackView.addArrangedSubview(commentButton)
        engagementStackView.addArrangedSubview(shareButton)
    }
    
    private func setupButton(_ button: UIButton, title: String, iconName: String, action: Selector) {
        var config = UIButton.Configuration.plain()
        config.title = title
        config.image = UIImage(systemName: iconName)
        config.imagePadding = 8
        config.imagePlacement = .leading
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            outgoing.foregroundColor = UIColor.systemGray
            return outgoing
        }
        
        button.configuration = config
        button.tintColor = .systemGray
        button.addTarget(self, action: action, for: .touchUpInside)
    }
    
    private func formatNumber(_ number: Int) -> String {
        if number >= 1000000 {
            return String(format: "%.1fM", Double(number) / 1000000)
        } else if number >= 1000 {
            return String(format: "%.1fK", Double(number) / 1000)
        }
        return "\(number)"
    }
    
    @objc private func likeButtonTapped() {
        
    }
    
    @objc private func commentButtonTapped() {
        toggleComments()
    }
    
    @objc private func shareButtonTapped() {
        
    }
    
    func configure(with post: PostModel) {
        currentPost = post
        usernameLabel.text = post.username
        timestampLabel.text = post.timeAgo
        contentLabel.text = post.content
        
        // Update engagement stats
        likesLabel.text = formatNumber(post.likes)
        commentsLabel.text = "\(formatNumber(post.comments)) komentárov"
        sharesLabel.text = "\(formatNumber(post.shares)) zdieľaní"
        
        if let profileImage = post.profileImage {
            profileImageView.image = profileImage
        } else {
            profileImageView.backgroundColor = .systemGray4
        }
        
        // Reset comments state
        showComments = false
        updateCommentsVisibility()
    }
    
    private func setupCommentsSection() {
        commentsContainerView.backgroundColor = UIColor(red: 0.975, green: 0.975, blue: 0.975, alpha: 1.0) // gray-50
        commentsContainerView.translatesAutoresizingMaskIntoConstraints = false
        commentsContainerView.isHidden = true
        containerView.addSubview(commentsContainerView)
        
        commentsStackView.axis = .vertical
        commentsStackView.spacing = 12
        commentsStackView.translatesAutoresizingMaskIntoConstraints = false
        commentsContainerView.addSubview(commentsStackView)
        
        NSLayoutConstraint.activate([
            commentsStackView.topAnchor.constraint(equalTo: commentsContainerView.topAnchor, constant: 12),
            commentsStackView.leadingAnchor.constraint(equalTo: commentsContainerView.leadingAnchor, constant: 16),
            commentsStackView.trailingAnchor.constraint(equalTo: commentsContainerView.trailingAnchor, constant: -16),
            commentsStackView.bottomAnchor.constraint(equalTo: commentsContainerView.bottomAnchor, constant: -12)
        ])
    }
    
    private func toggleComments() {
        showComments.toggle()
        updateCommentsVisibility()
    }
    
    private func updateCommentsVisibility() {
        commentsContainerView.isHidden = !showComments
        
        if showComments {
            loadCommentsUI()
        } else {
            clearCommentsUI()
        }
    }
    
    private func loadCommentsUI() {
        guard let post = currentPost else { return }
        let comments = post.commentList
        
        clearCommentsUI()
        
        // Add title
        let titleLabel = UILabel()
        titleLabel.text = "Komentáre"
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        titleLabel.textColor = UIColor(red: 0.374, green: 0.374, blue: 0.374, alpha: 1.0) // gray-600
        commentsStackView.addArrangedSubview(titleLabel)
        
        // Add comments
        for comment in comments {
            let commentView = createCommentView(comment: comment)
            commentsStackView.addArrangedSubview(commentView)
        }
    }
    
    private func clearCommentsUI() {
        commentsStackView.arrangedSubviews.forEach { view in
            commentsStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
    
    private func createCommentView(comment: CommentModel) -> UIView {
        let containerView = UIView()
        
        let avatarImageView = UIImageView()
        avatarImageView.backgroundColor = .systemGray4
        avatarImageView.layer.cornerRadius = 16
        avatarImageView.clipsToBounds = true
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let contentView = UIView()
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        let authorLabel = UILabel()
        authorLabel.text = comment.author
        authorLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        authorLabel.textColor = .black
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let timeLabel = UILabel()
        timeLabel.text = comment.timeAgo
        timeLabel.font = UIFont.systemFont(ofSize: 12)
        timeLabel.textColor = .systemGray
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let commentLabel = UILabel()
        commentLabel.text = comment.content
        commentLabel.font = UIFont.systemFont(ofSize: 14)
        commentLabel.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0) // gray-800
        commentLabel.numberOfLines = 0
        commentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let actionsView = UIView()
        actionsView.translatesAutoresizingMaskIntoConstraints = false
        
        let likeActionButton = UIButton()
        likeActionButton.setTitle("Páči sa mi (\(comment.likes))", for: .normal)
        likeActionButton.setTitleColor(.systemGray, for: .normal)
        likeActionButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        likeActionButton.translatesAutoresizingMaskIntoConstraints = false
        
        let replyActionButton = UIButton()
        replyActionButton.setTitle("Odpovedať", for: .normal)
        replyActionButton.setTitleColor(.systemGray, for: .normal)
        replyActionButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        replyActionButton.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(avatarImageView)
        containerView.addSubview(contentView)
        containerView.addSubview(actionsView)
        contentView.addSubview(authorLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(commentLabel)
        actionsView.addSubview(likeActionButton)
        actionsView.addSubview(replyActionButton)
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 32),
            avatarImageView.heightAnchor.constraint(equalToConstant: 32),
            
            contentView.topAnchor.constraint(equalTo: containerView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 8),
            contentView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            authorLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            authorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            
            timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            timeLabel.leadingAnchor.constraint(equalTo: authorLabel.trailingAnchor, constant: 8),
            timeLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -12),
            
            commentLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 4),
            commentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            commentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            commentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            actionsView.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 4),
            actionsView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 20),
            actionsView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            actionsView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            actionsView.heightAnchor.constraint(equalToConstant: 24),
            
            likeActionButton.leadingAnchor.constraint(equalTo: actionsView.leadingAnchor),
            likeActionButton.centerYAnchor.constraint(equalTo: actionsView.centerYAnchor),
            
            replyActionButton.leadingAnchor.constraint(equalTo: likeActionButton.trailingAnchor, constant: 16),
            replyActionButton.centerYAnchor.constraint(equalTo: actionsView.centerYAnchor)
        ])
        
        return containerView
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        usernameLabel.text = nil
        timestampLabel.text = nil
        contentLabel.text = nil
        profileImageView.image = nil
        profileImageView.backgroundColor = .systemGray4
        showComments = false
        clearCommentsUI()
        commentsContainerView.isHidden = true
    }
}