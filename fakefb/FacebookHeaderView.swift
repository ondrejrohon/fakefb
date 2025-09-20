//
//  FacebookHeaderView.swift
//  fakefb
//
//  Created by Claude on 20/09/2025.
//

import UIKit

protocol FacebookHeaderDelegate: AnyObject {
    func didTapSearch()
    func didTapHeaderMessages()
    func didTapHeaderNotifications()
    func didTapHeaderWatch()
}

class FacebookHeaderView: UIView {
    
    weak var delegate: FacebookHeaderDelegate?
    
    private let statusBarHeight: CGFloat = 20
    private let headerHeight: CGFloat = 44
    private let totalHeight: CGFloat = 64 // 20 + 44
    
    private let containerView = UIView()
    private let logoLabel = UILabel()
    private let searchBar = UITextField()
    private let searchIconView = UIImageView()
    private let messagesButton = UIButton()
    private let notificationsButton = UIButton()
    private let watchButton = UIButton()
    
    private var scrollView: UIScrollView?
    private var previousScrollOffset: CGFloat = 0
    private var isHeaderVisible = true
    private let hideThreshold: CGFloat = 20
    
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
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        
        setupLogo()
        setupRightButtons()
        setupSearchBar()
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: statusBarHeight),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: headerHeight)
        ])
    }
    
    private func setupLogo() {
        logoLabel.text = "facebook"
        logoLabel.textColor = .white
        logoLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        logoLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(logoLabel)
        
        NSLayoutConstraint.activate([
            logoLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            logoLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }
    
    private func setupSearchBar() {
        searchBar.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.2)
        searchBar.layer.cornerRadius = 8
        searchBar.textColor = .white
        searchBar.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [.foregroundColor: UIColor(red: 1, green: 1, blue: 1, alpha: 0.7)]
        )
        searchBar.font = UIFont.systemFont(ofSize: 16)
        searchBar.borderStyle = .none
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        searchIconView.image = UIImage(systemName: "magnifyingglass")
        searchIconView.tintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.7)
        searchIconView.contentMode = .scaleAspectFit
        searchIconView.translatesAutoresizingMaskIntoConstraints = false
        
        searchBar.leftView = searchIconView
        searchBar.leftViewMode = .always
        searchBar.addTarget(self, action: #selector(searchBarTapped), for: .editingDidBegin)
        
        containerView.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchIconView.widthAnchor.constraint(equalToConstant: 24),
            searchIconView.heightAnchor.constraint(equalToConstant: 24),
            
            searchBar.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 36),
            searchBar.leadingAnchor.constraint(equalTo: logoLabel.trailingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: watchButton.leadingAnchor, constant: -16)
        ])
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 36))
        searchBar.rightView = paddingView
        searchBar.rightViewMode = .always
    }
    
    private func setupRightButtons() {
        // Watch button
        watchButton.setImage(UIImage(systemName: "play.circle"), for: .normal)
        watchButton.tintColor = .white
        watchButton.addTarget(self, action: #selector(watchButtonTapped), for: .touchUpInside)
        watchButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(watchButton)
        
        // Notifications button
        notificationsButton.setImage(UIImage(systemName: "bell"), for: .normal)
        notificationsButton.tintColor = .white
        notificationsButton.addTarget(self, action: #selector(notificationsButtonTapped), for: .touchUpInside)
        notificationsButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(notificationsButton)
        
        // Messages button
        messagesButton.setImage(UIImage(systemName: "message"), for: .normal)
        messagesButton.tintColor = .white
        messagesButton.addTarget(self, action: #selector(messagesButtonTapped), for: .touchUpInside)
        messagesButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(messagesButton)
        
        NSLayoutConstraint.activate([
            // Watch button (rightmost)
            watchButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            watchButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            watchButton.widthAnchor.constraint(equalToConstant: 24),
            watchButton.heightAnchor.constraint(equalToConstant: 24),
            
            // Notifications button
            notificationsButton.trailingAnchor.constraint(equalTo: watchButton.leadingAnchor, constant: -16),
            notificationsButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            notificationsButton.widthAnchor.constraint(equalToConstant: 24),
            notificationsButton.heightAnchor.constraint(equalToConstant: 24),
            
            // Messages button
            messagesButton.trailingAnchor.constraint(equalTo: notificationsButton.leadingAnchor, constant: -16),
            messagesButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            messagesButton.widthAnchor.constraint(equalToConstant: 24),
            messagesButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    // MARK: - Button Actions
    @objc private func searchBarTapped() {
        delegate?.didTapSearch()
    }
    
    @objc private func messagesButtonTapped() {
        delegate?.didTapHeaderMessages()
    }
    
    @objc private func notificationsButtonTapped() {
        delegate?.didTapHeaderNotifications()
    }
    
    @objc private func watchButtonTapped() {
        delegate?.didTapHeaderWatch()
    }
    
    // MARK: - Scroll Behavior
    func attachToScrollView(_ scrollView: UIScrollView) {
        self.scrollView = scrollView
    }
    
    func handleScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let difference = currentOffset - previousScrollOffset
        let velocity = scrollView.panGestureRecognizer.velocity(in: scrollView).y
        
        // Only handle scroll when not at top and has scrolled enough
        guard currentOffset > 0 else {
            showHeader(animated: true)
            previousScrollOffset = currentOffset
            return
        }
        
        // Determine scroll direction and handle accordingly
        if difference > 0 && currentOffset > hideThreshold {
            // Scrolling down - hide header
            if isHeaderVisible {
                hideHeader(animated: true, velocity: abs(velocity))
            }
        } else if difference < 0 {
            // Scrolling up - show header
            if !isHeaderVisible {
                showHeader(animated: true, velocity: abs(velocity))
            }
        }
        
        previousScrollOffset = currentOffset
    }
    
    private func hideHeader(animated: Bool, velocity: CGFloat = 0) {
        guard isHeaderVisible else { return }
        isHeaderVisible = false
        
        let duration = animated ? min(0.3, max(0.1, 300.0 / velocity)) : 0
        
        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseInOut], animations: {
            self.transform = CGAffineTransform(translationX: 0, y: -self.totalHeight)
        })
    }
    
    private func showHeader(animated: Bool, velocity: CGFloat = 0) {
        guard !isHeaderVisible else { return }
        isHeaderVisible = true
        
        let duration = animated ? min(0.3, max(0.1, 300.0 / velocity)) : 0
        
        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseInOut], animations: {
            self.transform = .identity
        })
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: totalHeight)
    }
}