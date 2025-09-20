//
//  FacebookHeaderView.swift
//  fakefb
//
//  Created by Claude on 20/09/2025.
//

import UIKit

protocol FacebookHeaderDelegate: AnyObject {
    func didTapSearch()
    func didTapCamera()
    func didTapMessenger()
}

class FacebookHeaderView: UIView {
    
    weak var delegate: FacebookHeaderDelegate?
    
    private let statusBarHeight: CGFloat = 20
    private let headerHeight: CGFloat = 44
    private let totalHeight: CGFloat = 64 // 20 + 44
    
    private let containerView = UIView()
    private let cameraButton = UIButton()
    private let searchBar = UITextField()
    private let searchIconView = UIImageView()
    private let messengerButton = UIButton()
    
    private var scrollView: UIScrollView?
    private var previousScrollOffset: CGFloat = 0
    private var isHeaderVisible = true
    private let hideThreshold: CGFloat = 20
    
    // Add height constraint to control visibility
    private var heightConstraint: NSLayoutConstraint?
    
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
        clipsToBounds = true // This will clip the content when it moves up
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        
        setupCameraButton()
        setupMessengerButton()
        setupSearchBar()
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: statusBarHeight),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: headerHeight)
        ])
    }
    
    func setupHeightConstraint() {
        heightConstraint = heightAnchor.constraint(equalToConstant: totalHeight)
        heightConstraint?.isActive = true
    }
    
    private func setupCameraButton() {
        cameraButton.setImage(UIImage(systemName: "camera"), for: .normal)
        cameraButton.tintColor = .white
        cameraButton.addTarget(self, action: #selector(cameraButtonTapped), for: .touchUpInside)
        cameraButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(cameraButton)
        
        NSLayoutConstraint.activate([
            cameraButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            cameraButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            cameraButton.widthAnchor.constraint(equalToConstant: 24),
            cameraButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    private func setupSearchBar() {
        // Create a more subtle background color similar to Facebook's design
        searchBar.backgroundColor = UIColor(red: 0.2, green: 0.3, blue: 0.5, alpha: 0.6)
        searchBar.layer.cornerRadius = 18 // More rounded like in the original
        searchBar.textColor = .white
        searchBar.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [.foregroundColor: UIColor(red: 1, green: 1, blue: 1, alpha: 0.8)]
        )
        searchBar.font = UIFont.systemFont(ofSize: 16)
        searchBar.borderStyle = .none
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        searchIconView.image = UIImage(systemName: "magnifyingglass")
        searchIconView.tintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8)
        searchIconView.contentMode = .scaleAspectFit
        searchIconView.translatesAutoresizingMaskIntoConstraints = false
        
        // Create a container view for better icon positioning with Auto Layout
        let leftContainer = UIView()
        leftContainer.translatesAutoresizingMaskIntoConstraints = false
        leftContainer.addSubview(searchIconView)
        
        NSLayoutConstraint.activate([
            leftContainer.widthAnchor.constraint(equalToConstant: 40),
            leftContainer.heightAnchor.constraint(equalToConstant: 36),
            searchIconView.centerXAnchor.constraint(equalTo: leftContainer.centerXAnchor),
            searchIconView.centerYAnchor.constraint(equalTo: leftContainer.centerYAnchor),
            searchIconView.widthAnchor.constraint(equalToConstant: 20),
            searchIconView.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        searchBar.leftView = leftContainer
        searchBar.leftViewMode = .always
        searchBar.addTarget(self, action: #selector(searchBarTapped), for: .editingDidBegin)
        
        containerView.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchBar.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 36),
            searchBar.leadingAnchor.constraint(equalTo: cameraButton.trailingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: messengerButton.leadingAnchor, constant: -16)
        ])
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 36))
        searchBar.rightView = paddingView
        searchBar.rightViewMode = .always
    }
    
    private func setupMessengerButton() {
        // Use the messenger icon (speech bubble with lightning bolt)
        messengerButton.setImage(UIImage(systemName: "message.fill"), for: .normal)
        messengerButton.tintColor = .white
        messengerButton.addTarget(self, action: #selector(messengerButtonTapped), for: .touchUpInside)
        messengerButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(messengerButton)
        
        NSLayoutConstraint.activate([
            messengerButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            messengerButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            messengerButton.widthAnchor.constraint(equalToConstant: 24),
            messengerButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    // MARK: - Button Actions
    @objc private func searchBarTapped() {
        delegate?.didTapSearch()
    }
    
    @objc private func cameraButtonTapped() {
        delegate?.didTapCamera()
    }
    
    @objc private func messengerButtonTapped() {
        delegate?.didTapMessenger()
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
        guard isHeaderVisible, let heightConstraint = heightConstraint else { return }
        isHeaderVisible = false
        
        let duration = animated ? min(0.3, max(0.1, 300.0 / velocity)) : 0
        
        if animated {
            UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseInOut], animations: {
                // Slide the container view up, and reduce the height to 0 for layout
                self.containerView.transform = CGAffineTransform(translationX: 0, y: -self.totalHeight)
                heightConstraint.constant = 0
                self.superview?.layoutIfNeeded()
            })
        } else {
            containerView.transform = CGAffineTransform(translationX: 0, y: -totalHeight)
            heightConstraint.constant = 0
            superview?.layoutIfNeeded()
        }
    }
    
    private func showHeader(animated: Bool, velocity: CGFloat = 0) {
        guard !isHeaderVisible, let heightConstraint = heightConstraint else { return }
        isHeaderVisible = true
        
        let duration = animated ? min(0.3, max(0.1, 300.0 / velocity)) : 0
        
        // First restore the height constraint
        heightConstraint.constant = totalHeight
        
        if animated {
            UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseInOut], animations: {
                // Slide the container view back down
                self.containerView.transform = .identity
                self.superview?.layoutIfNeeded()
            })
        } else {
            containerView.transform = .identity
            superview?.layoutIfNeeded()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        let height = isHeaderVisible ? totalHeight : 0
        return CGSize(width: UIView.noIntrinsicMetric, height: height)
    }
}