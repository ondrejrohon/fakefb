//
//  CreatePostView.swift
//  fakefb
//
//  Created by Claude on 02/10/2025.
//

import UIKit

protocol CreatePostViewDelegate: AnyObject {
    func didTapCreatePost()
}

class CreatePostView: UIView {
    
    weak var delegate: CreatePostViewDelegate?
    
    private let containerView = UIView()
    private let avatarImageView = UIImageView()
    private let postButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .white
        
        // Add border to match web app
        layer.borderWidth = 1
        layer.borderColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1.0).cgColor // Gray-200
        
        setupContainerView()
        setupAvatarImageView()
        setupPostButton()
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            containerView.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    private func setupContainerView() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
    }
    
    private func setupAvatarImageView() {
        avatarImageView.backgroundColor = UIColor(red: 0.255, green: 0.4, blue: 0.698, alpha: 1.0) // #4167B2
        avatarImageView.layer.cornerRadius = 24
        avatarImageView.clipsToBounds = true
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add "Vy" text as placeholder
        let label = UILabel()
        label.text = "Vy"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        avatarImageView.addSubview(label)
        containerView.addSubview(avatarImageView)
        
        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            avatarImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 48),
            avatarImageView.heightAnchor.constraint(equalToConstant: 48),
            
            label.centerXAnchor.constraint(equalTo: avatarImageView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor)
        ])
    }
    
    private func setupPostButton() {
        postButton.setTitle("Čo máte na mysli?", for: .normal)
        postButton.setTitleColor(UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0), for: .normal)
        postButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        postButton.contentHorizontalAlignment = .left
        postButton.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0)
        postButton.layer.cornerRadius = 24
        postButton.layer.borderWidth = 1
        postButton.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        postButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        postButton.translatesAutoresizingMaskIntoConstraints = false
        
        postButton.addTarget(self, action: #selector(postButtonTapped), for: .touchUpInside)
        
        containerView.addSubview(postButton)
        
        NSLayoutConstraint.activate([
            postButton.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 8),
            postButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            postButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            postButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    @objc private func postButtonTapped() {
        delegate?.didTapCreatePost()
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 80)
    }
}