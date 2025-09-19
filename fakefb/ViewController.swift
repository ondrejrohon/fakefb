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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        optimizeForPerformance()
        setupTableView()
        setupVideoManager()
        setupFPSCounter()
        loadFeedData()
    }
    
    private func optimizeForPerformance() {
        view.backgroundColor = .systemBackground
        view.layer.drawsAsynchronously = true
        view.layer.shouldRasterize = false
        
        if let window = view.window {
            window.layer.allowsGroupOpacity = false
        }
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
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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
        tableView.reloadData()
    }
}

extension FeedViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateVisibleVideos()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updateVisibleVideos()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            updateVisibleVideos()
        }
    }
    
    private func updateVisibleVideos() {
        let visibleCells = tableView.visibleCells
        var visibleVideoCells: [VideoPostCell] = []
        
        for cell in visibleCells {
            if let videoCell = cell as? VideoPostCell {
                let cellFrame = tableView.convert(cell.frame, to: view)
                let visibleHeight = min(cellFrame.maxY, view.bounds.height) - max(cellFrame.minY, 0)
                let cellHeight = cell.frame.height
                
                if visibleHeight > cellHeight * 0.6 {
                    visibleVideoCells.append(videoCell)
                }
            }
        }
        
        videoManager.updateVisibleCells(visibleVideoCells)
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

