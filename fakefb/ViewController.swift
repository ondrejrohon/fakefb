//
//  ViewController.swift
//  fakefb
//
//  Created by Ondrej Rohon on 19/09/2025.
//

import UIKit
import AVFoundation

class FeedViewController: UIViewController {
    
    private var tableView: UITableView!
    private var feedDataSource: FeedDataSource!
    private var videoManager: VideoManager!
    private var fpsCounter: FPSCounter?
    private var scrollTimer: Timer?
    
    private var facebookHeaderView: FacebookHeaderView!
    private var facebookTabBarView: FacebookTabBarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        optimizeForPerformance()
        setupFacebookHeader()
        setupFacebookTabBar()
        setupTableView()
        setupVideoManager()
        // setupFPSCounter()
        loadFeedData()
    }
    
    private func optimizeForPerformance() {
        view.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.0)
        view.layer.drawsAsynchronously = true
        view.layer.shouldRasterize = false
        
        if let window = view.window {
            window.layer.allowsGroupOpacity = false
        }
    }
    
    private func setupFacebookHeader() {
        // Hide the default navigation bar
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        facebookHeaderView = FacebookHeaderView()
        facebookHeaderView.delegate = self
        facebookHeaderView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(facebookHeaderView)
        
        NSLayoutConstraint.activate([
            facebookHeaderView.topAnchor.constraint(equalTo: view.topAnchor),
            facebookHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            facebookHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        // Let the header manage its own height constraint
        facebookHeaderView.setupHeightConstraint()
    }
    
    private func setupFacebookTabBar() {
        facebookTabBarView = FacebookTabBarView()
        facebookTabBarView.delegate = self
        facebookTabBarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(facebookTabBarView)
        
        NSLayoutConstraint.activate([
            facebookTabBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            facebookTabBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            facebookTabBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            facebookTabBarView.heightAnchor.constraint(equalToConstant: 49)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        videoManager.resumePlayback()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        videoManager.pauseAllVideos()
    }
    
    private func setupTableView() {
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: facebookHeaderView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: facebookTabBarView.topAnchor)
        ])
        
        tableView.register(TextPostCell.self, forCellReuseIdentifier: "TextPostCell")
        tableView.register(ImagePostCell.self, forCellReuseIdentifier: "ImagePostCell")
        tableView.register(VideoPostCell.self, forCellReuseIdentifier: "VideoPostCell")
        
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.estimatedRowHeight = 350
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.contentInsetAdjustmentBehavior = .automatic
        tableView.insetsContentViewsToSafeArea = true
        
        tableView.decelerationRate = UIScrollView.DecelerationRate.fast
        tableView.alwaysBounceVertical = true
        
        tableView.prefetchDataSource = feedDataSource
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        
        tableView.delegate = self
    }
    
    private func setupVideoManager() {
        videoManager = VideoManager()
        videoManager.delegate = self
    }
    
    private func setupFPSCounter() {
        fpsCounter = FPSCounter()
        if let fpsCounter = fpsCounter {
            view.addSubview(fpsCounter)
            fpsCounter.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                fpsCounter.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
                fpsCounter.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
                fpsCounter.widthAnchor.constraint(equalToConstant: 80),
                fpsCounter.heightAnchor.constraint(equalToConstant: 30)
            ])
        }
    }
    
    private func loadFeedData() {
        feedDataSource = FeedDataSource()
        tableView.dataSource = feedDataSource
        feedDataSource.videoManager = videoManager
        
        // Attach the scroll view to the header for quick return behavior
        facebookHeaderView.attachToScrollView(tableView)
        
        tableView.reloadData()
    }
}

extension FeedViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Handle quick return header behavior
        facebookHeaderView.handleScroll(scrollView)
        
        // Update videos immediately during scrolling to maintain playback of visible videos
        updateVisibleVideos()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updateVisibleVideos()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        updateVisibleVideos()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // Don't pause all videos - let updateVisibleVideos handle which ones should play/pause
        updateVisibleVideos()
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        updateVisibleVideos()
    }
    
    private func updateVisibleVideos() {
        let visibleCells = tableView.visibleCells
        var visibleVideoCellsWithVisibility: [(cell: VideoPostCell, visibilityRatio: CGFloat)] = []
        var outOfViewVideoCells: [VideoPostCell] = []
        
        // Check all video cells and calculate their visibility ratio
        for indexPath in tableView.indexPathsForVisibleRows ?? [] {
            if let cell = tableView.cellForRow(at: indexPath) as? VideoPostCell {
                let cellFrame = tableView.convert(cell.frame, to: view)
                let visibleHeight = min(cellFrame.maxY, view.bounds.height) - max(cellFrame.minY, 0)
                let cellHeight = cell.frame.height
                let visibilityRatio = max(0, visibleHeight / cellHeight)
                
                // Cell is considered visible if more than 60% is showing
                if visibilityRatio > 0.6 && cellFrame.maxY > 0 && cellFrame.minY < view.bounds.height {
                    visibleVideoCellsWithVisibility.append((cell, visibilityRatio))
                } else {
                    outOfViewVideoCells.append(cell)
                }
            }
        }
        
        // Sort by visibility ratio (most visible first)
        visibleVideoCellsWithVisibility.sort { $0.visibilityRatio > $1.visibilityRatio }
        let visibleVideoCells = visibleVideoCellsWithVisibility.map { $0.cell }
        
        // Also check for any video cells that might be completely off-screen
        let allVideoCells = tableView.visibleCells.compactMap { $0 as? VideoPostCell }
        for cell in allVideoCells {
            if !visibleVideoCells.contains(cell) && !outOfViewVideoCells.contains(cell) {
                outOfViewVideoCells.append(cell)
            }
        }
        
        videoManager.updateVisibleCells(visibleVideoCells, outOfViewCells: outOfViewVideoCells)
    }
}

extension FeedViewController: VideoManagerDelegate {
    func videoDidStartPlaying(_ cell: VideoPostCell) {
        
    }
    
    func videoDidStopPlaying(_ cell: VideoPostCell) {
        
    }
    
    func videoDidFailToLoad(_ cell: VideoPostCell, error: Error) {
        print("Video failed to load: \(error.localizedDescription)")
    }
}

extension FeedViewController: FacebookHeaderDelegate {
    func didTapSearch() {
        print("Search tapped")
    }
    
    func didTapCamera() {
        print("Camera tapped")
    }
    
    func didTapMessenger() {
        print("Messenger tapped")
    }
}

extension FeedViewController: FacebookTabBarDelegate {
    func didTapHome() {
        print("Tab Home tapped")
    }
    
    func didTapWatch() {
        print("Tab Watch tapped")
    }
    
    func didTapMarketplace() {
        print("Tab Marketplace tapped")
    }
    
    func didTapNotifications() {
        print("Tab Notifications tapped")
    }
    
    func didTapMenu() {
        print("Tab Menu tapped")
    }
}

