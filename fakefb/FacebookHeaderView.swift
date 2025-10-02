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
        backgroundColor = UIColor(red: 0.255, green: 0.4, blue: 0.698, alpha: 1.0) // #4167B2 - exact match
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
        let cameraIcon = createCameraIcon()
        cameraButton.setImage(cameraIcon, for: .normal)
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
        // Create a more subtle background color matching web app's design
        searchBar.backgroundColor = UIColor(red: 0.161, green: 0.282, blue: 0.494, alpha: 1.0) // #29487E
        searchBar.layer.cornerRadius = 4 // Match web app's subtle rounding
        searchBar.textColor = .white
        searchBar.attributedPlaceholder = NSAttributedString(
            string: "Hľadať",
            attributes: [.foregroundColor: UIColor(red: 0.384, green: 0.506, blue: 0.718, alpha: 1.0)] // #6281B7
        )
        searchBar.font = UIFont.systemFont(ofSize: 16)
        searchBar.borderStyle = .none
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        searchIconView.image = UIImage(systemName: "magnifyingglass")
        searchIconView.tintColor = UIColor(red: 0.384, green: 0.506, blue: 0.718, alpha: 1.0) // #6281B7
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
        let messengerIcon = createMessengerIcon()
        messengerButton.setImage(messengerIcon, for: .normal)
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
    
    // MARK: - Custom Icon Creation
    private func createCameraIcon() -> UIImage {
        let size = CGSize(width: 22, height: 18)
        let renderer = UIGraphicsImageRenderer(size: size)
        
        return renderer.image { context in
            let cgContext = context.cgContext
            
            // Camera SVG path from web app
            let path = UIBezierPath()
            
            // Main camera body
            path.move(to: CGPoint(x: 16, y: 0))
            path.addCurve(to: CGPoint(x: 17, y: 1), controlPoint1: CGPoint(x: 16.5523, y: 0), controlPoint2: CGPoint(x: 17, y: 0.447715))
            path.addLine(to: CGPoint(x: 17, y: 3))
            path.addLine(to: CGPoint(x: 20, y: 3))
            path.addCurve(to: CGPoint(x: 22, y: 5), controlPoint1: CGPoint(x: 21.1046, y: 3), controlPoint2: CGPoint(x: 22, y: 3.89543))
            path.addLine(to: CGPoint(x: 22, y: 16))
            path.addCurve(to: CGPoint(x: 20, y: 18), controlPoint1: CGPoint(x: 22, y: 17.1046), controlPoint2: CGPoint(x: 21.1046, y: 18))
            path.addLine(to: CGPoint(x: 2, y: 18))
            path.addCurve(to: CGPoint(x: 0, y: 16), controlPoint1: CGPoint(x: 0.895431, y: 18), controlPoint2: CGPoint(x: 0, y: 17.1046))
            path.addLine(to: CGPoint(x: 0, y: 5))
            path.addCurve(to: CGPoint(x: 2, y: 3), controlPoint1: CGPoint(x: 0, y: 3.89543), controlPoint2: CGPoint(x: 0.895431, y: 3))
            path.addLine(to: CGPoint(x: 6, y: 3))
            path.addLine(to: CGPoint(x: 6, y: 1))
            path.addCurve(to: CGPoint(x: 7, y: 0), controlPoint1: CGPoint(x: 6, y: 0.447715), controlPoint2: CGPoint(x: 6.44772, y: 0))
            path.addLine(to: CGPoint(x: 16, y: 0))
            path.close()
            
            // Camera lens (outer)
            path.move(to: CGPoint(x: 11, y: 4))
            path.addCurve(to: CGPoint(x: 5, y: 10), controlPoint1: CGPoint(x: 7.68629, y: 4), controlPoint2: CGPoint(x: 5, y: 6.68629))
            path.addCurve(to: CGPoint(x: 11, y: 16), controlPoint1: CGPoint(x: 5, y: 13.3137), controlPoint2: CGPoint(x: 7.68629, y: 16))
            path.addCurve(to: CGPoint(x: 17, y: 10), controlPoint1: CGPoint(x: 14.3137, y: 16), controlPoint2: CGPoint(x: 17, y: 13.3137))
            path.addCurve(to: CGPoint(x: 11, y: 4), controlPoint1: CGPoint(x: 17, y: 6.68629), controlPoint2: CGPoint(x: 14.3137, y: 4))
            path.close()
            
            // Camera lens (inner)
            path.move(to: CGPoint(x: 11, y: 5))
            path.addCurve(to: CGPoint(x: 16, y: 10), controlPoint1: CGPoint(x: 13.7614, y: 5), controlPoint2: CGPoint(x: 16, y: 7.23858))
            path.addCurve(to: CGPoint(x: 11, y: 15), controlPoint1: CGPoint(x: 16, y: 12.7614), controlPoint2: CGPoint(x: 13.7614, y: 15))
            path.addCurve(to: CGPoint(x: 6, y: 10), controlPoint1: CGPoint(x: 8.23858, y: 15), controlPoint2: CGPoint(x: 6, y: 12.7614))
            path.addCurve(to: CGPoint(x: 11, y: 5), controlPoint1: CGPoint(x: 6, y: 7.23858), controlPoint2: CGPoint(x: 8.23858, y: 5))
            path.close()
            
            // Flash/viewfinder
            path.move(to: CGPoint(x: 18.5, y: 5.5))
            path.addCurve(to: CGPoint(x: 17.5, y: 6.5), controlPoint1: CGPoint(x: 17.9477, y: 5.5), controlPoint2: CGPoint(x: 17.5, y: 5.94772))
            path.addCurve(to: CGPoint(x: 18.5, y: 7.5), controlPoint1: CGPoint(x: 17.5, y: 7.05228), controlPoint2: CGPoint(x: 17.9477, y: 7.5))
            path.addCurve(to: CGPoint(x: 19.5, y: 6.5), controlPoint1: CGPoint(x: 19.0523, y: 7.5), controlPoint2: CGPoint(x: 19.5, y: 7.05228))
            path.addCurve(to: CGPoint(x: 18.5, y: 5.5), controlPoint1: CGPoint(x: 19.5, y: 5.94772), controlPoint2: CGPoint(x: 19.0523, y: 5.5))
            path.close()
            
            cgContext.setFillColor(UIColor.white.cgColor)
            cgContext.addPath(path.cgPath)
            cgContext.fillPath()
        }
    }
    
    private func createMessengerIcon() -> UIImage {
        let size = CGSize(width: 20, height: 20)
        let renderer = UIGraphicsImageRenderer(size: size)
        
        return renderer.image { context in
            let cgContext = context.cgContext
            
            // Scale and adjust the complex messenger path from the web app
            let path = UIBezierPath()
            
            // Simplified messenger bubble shape
            path.move(to: CGPoint(x: 10, y: 2))
            path.addCurve(to: CGPoint(x: 18, y: 10), controlPoint1: CGPoint(x: 14.5, y: 2), controlPoint2: CGPoint(x: 18, y: 5.5))
            path.addCurve(to: CGPoint(x: 10, y: 18), controlPoint1: CGPoint(x: 18, y: 14.5), controlPoint2: CGPoint(x: 14.5, y: 18))
            path.addCurve(to: CGPoint(x: 2, y: 10), controlPoint1: CGPoint(x: 5.5, y: 18), controlPoint2: CGPoint(x: 2, y: 14.5))
            path.addCurve(to: CGPoint(x: 10, y: 2), controlPoint1: CGPoint(x: 2, y: 5.5), controlPoint2: CGPoint(x: 5.5, y: 2))
            path.close()
            
            // Inner lightning/arrow shape
            path.move(to: CGPoint(x: 8, y: 7))
            path.addLine(to: CGPoint(x: 12, y: 10))
            path.addLine(to: CGPoint(x: 8, y: 13))
            path.addLine(to: CGPoint(x: 9, y: 10))
            path.close()
            
            cgContext.setFillColor(UIColor.white.cgColor)
            cgContext.addPath(path.cgPath)
            cgContext.fillPath()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        let height = isHeaderVisible ? totalHeight : 0
        return CGSize(width: UIView.noIntrinsicMetric, height: height)
    }
}