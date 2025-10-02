//
//  StoriesView.swift
//  fakefb
//
//  Created by Claude on 02/10/2025.
//

import UIKit

struct Story {
    let id: Int
    let name: String
    let profilePicture: String
    let hasNotification: Bool
}

class StoriesView: UIView {
    
    private let collectionView: UICollectionView
    private var stories: [Story] = []
    
    override init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 8, bottom: 8, right: 8)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        super.init(frame: frame)
        
        setupView()
        setupCollectionView()
        loadStories()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .white
        
        // Add bottom border to match web app
        layer.borderWidth = 0
        let bottomBorder = CALayer()
        bottomBorder.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        bottomBorder.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 1)
        layer.addSublayer(bottomBorder)
        
        // Add top padding to account for header spacing like web app
        layer.borderColor = UIColor.clear.cgColor
    }
    
    private func setupCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(StoryCell.self, forCellWithReuseIdentifier: "StoryCell")
        collectionView.register(SendMessageCell.self, forCellWithReuseIdentifier: "SendMessageCell")
        collectionView.register(YourStoryCell.self, forCellWithReuseIdentifier: "YourStoryCell")
        
        addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    private func loadStories() {
        stories = [
            Story(id: 1, name: "Katarína", profilePicture: "https://i.pravatar.cc/150?img=5", hasNotification: false),
            Story(id: 2, name: "Marek", profilePicture: "https://i.pravatar.cc/150?img=15", hasNotification: false),
            Story(id: 3, name: "Simona", profilePicture: "https://i.pravatar.cc/150?img=10", hasNotification: false)
        ]
        
        collectionView.reloadData()
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 120)
    }
}

extension StoriesView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2 + stories.count // Send message + Your story + friends' stories
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SendMessageCell", for: indexPath) as! SendMessageCell
            return cell
        } else if indexPath.item == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YourStoryCell", for: indexPath) as! YourStoryCell
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoryCell", for: indexPath) as! StoryCell
            let story = stories[indexPath.item - 2]
            cell.configure(with: story)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 64, height: 88)
    }
}

// MARK: - Story Cells

class SendMessageCell: UICollectionViewCell {
    
    private let containerView = UIView()
    private let iconView = UIImageView()
    private let label = UILabel()
    private let notificationBadge = UIView()
    private let badgeLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        containerView.layer.cornerRadius = 32
        containerView.layer.borderWidth = 2
        containerView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        containerView.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.0)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        iconView.image = UIImage(systemName: "paperplane.fill")
        iconView.tintColor = UIColor(red: 0.255, green: 0.4, blue: 0.698, alpha: 1.0) // #4167B2
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        notificationBadge.backgroundColor = .systemRed
        notificationBadge.layer.cornerRadius = 10
        notificationBadge.translatesAutoresizingMaskIntoConstraints = false
        
        badgeLabel.text = "2"
        badgeLabel.textColor = .white
        badgeLabel.font = UIFont.boldSystemFont(ofSize: 12)
        badgeLabel.textAlignment = .center
        badgeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = "Odoslať"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(containerView)
        containerView.addSubview(iconView)
        contentView.addSubview(notificationBadge)
        notificationBadge.addSubview(badgeLabel)
        contentView.addSubview(label)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 64),
            containerView.heightAnchor.constraint(equalToConstant: 64),
            
            iconView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 24),
            iconView.heightAnchor.constraint(equalToConstant: 24),
            
            notificationBadge.topAnchor.constraint(equalTo: containerView.topAnchor, constant: -4),
            notificationBadge.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 4),
            notificationBadge.widthAnchor.constraint(equalToConstant: 20),
            notificationBadge.heightAnchor.constraint(equalToConstant: 20),
            
            badgeLabel.centerXAnchor.constraint(equalTo: notificationBadge.centerXAnchor),
            badgeLabel.centerYAnchor.constraint(equalTo: notificationBadge.centerYAnchor),
            
            label.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 4),
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor),
            label.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor)
        ])
    }
}

class YourStoryCell: UICollectionViewCell {
    
    private let imageView = UIImageView()
    private let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        imageView.layer.cornerRadius = 32
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        imageView.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.0)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Set placeholder image
        imageView.image = UIImage(systemName: "person.circle.fill")
        imageView.tintColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
        
        label.text = "Váš príbeh"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(imageView)
        contentView.addSubview(label)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 64),
            imageView.heightAnchor.constraint(equalToConstant: 64),
            
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4),
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor),
            label.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor)
        ])
        
        // Load actual profile image
        loadProfileImage()
    }
    
    private func loadProfileImage() {
        guard let url = URL(string: "https://i.pravatar.cc/100?img=1") else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data = data, let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                self?.imageView.image = image
            }
        }.resume()
    }
}

class StoryCell: UICollectionViewCell {
    
    private let imageView = UIImageView()
    private let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        imageView.layer.cornerRadius = 32
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        imageView.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.0)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(imageView)
        contentView.addSubview(label)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 64),
            imageView.heightAnchor.constraint(equalToConstant: 64),
            
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4),
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor),
            label.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor)
        ])
    }
    
    func configure(with story: Story) {
        label.text = story.name
        loadImage(from: story.profilePicture)
    }
    
    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data = data, let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                self?.imageView.image = image
            }
        }.resume()
    }
}