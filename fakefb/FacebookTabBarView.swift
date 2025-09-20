//
//  FacebookTabBarView.swift
//  fakefb
//
//  Created by Claude on 20/09/2025.
//

import UIKit

protocol FacebookTabBarDelegate: AnyObject {
    func didTapHome()
    func didTapWatch()
    func didTapMarketplace()
    func didTapNotifications()
    func didTapMenu()
}

class FacebookTabBarView: UIView {
    
    weak var delegate: FacebookTabBarDelegate?
    
    private let tabBarHeight: CGFloat = 49
    private let stackView = UIStackView()
    
    private let homeButton = UIButton()
    private let watchButton = UIButton()
    private let marketplaceButton = UIButton()
    private let notificationsButton = UIButton()
    private let menuButton = UIButton()
    
    private var selectedButton: UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = UIColor(red: 0.26, green: 0.40, blue: 0.70, alpha: 1.0) // #4267b2
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        setupTabButtons()
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        // Set home as selected by default
        selectButton(homeButton)
    }
    
    private func setupTabButtons() {
        // Home button
        homeButton.setImage(UIImage(systemName: "house.fill"), for: .normal)
        homeButton.tintColor = .white
        homeButton.addTarget(self, action: #selector(homeButtonTapped), for: .touchUpInside)
        configureButton(homeButton)
        
        // Watch button
        watchButton.setImage(UIImage(systemName: "play.tv"), for: .normal)
        watchButton.tintColor = UIColor(white: 1.0, alpha: 0.6)
        watchButton.addTarget(self, action: #selector(watchButtonTapped), for: .touchUpInside)
        configureButton(watchButton)
        
        // Marketplace button
        marketplaceButton.setImage(UIImage(systemName: "bag"), for: .normal)
        marketplaceButton.tintColor = UIColor(white: 1.0, alpha: 0.6)
        marketplaceButton.addTarget(self, action: #selector(marketplaceButtonTapped), for: .touchUpInside)
        configureButton(marketplaceButton)
        
        // Notifications button
        notificationsButton.setImage(UIImage(systemName: "bell"), for: .normal)
        notificationsButton.tintColor = UIColor(white: 1.0, alpha: 0.6)
        notificationsButton.addTarget(self, action: #selector(notificationsButtonTapped), for: .touchUpInside)
        configureButton(notificationsButton)
        
        // Menu button
        menuButton.setImage(UIImage(systemName: "line.horizontal.3"), for: .normal)
        menuButton.tintColor = UIColor(white: 1.0, alpha: 0.6)
        menuButton.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
        configureButton(menuButton)
        
        stackView.addArrangedSubview(homeButton)
        stackView.addArrangedSubview(watchButton)
        stackView.addArrangedSubview(marketplaceButton)
        stackView.addArrangedSubview(notificationsButton)
        stackView.addArrangedSubview(menuButton)
    }
    
    private func configureButton(_ button: UIButton) {
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 24),
            button.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    private func selectButton(_ button: UIButton) {
        // Deselect previous button
        selectedButton?.tintColor = UIColor(white: 1.0, alpha: 0.6)
        
        // Select new button
        selectedButton = button
        button.tintColor = .white
        
        // Add subtle scale animation
        UIView.animate(withDuration: 0.1, animations: {
            button.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                button.transform = .identity
            }
        }
    }
    
    // MARK: - Button Actions
    @objc private func homeButtonTapped() {
        selectButton(homeButton)
        delegate?.didTapHome()
    }
    
    @objc private func watchButtonTapped() {
        selectButton(watchButton)
        delegate?.didTapWatch()
    }
    
    @objc private func marketplaceButtonTapped() {
        selectButton(marketplaceButton)
        delegate?.didTapMarketplace()
    }
    
    @objc private func notificationsButtonTapped() {
        selectButton(notificationsButton)
        delegate?.didTapNotifications()
    }
    
    @objc private func menuButtonTapped() {
        selectButton(menuButton)
        delegate?.didTapMenu()
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: tabBarHeight)
    }
}