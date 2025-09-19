//
//  VideoManager.swift
//  fakefb
//
//  Created by Claude on 19/09/2025.
//

import UIKit
import AVFoundation

protocol VideoManagerDelegate: AnyObject {
    func videoDidStartPlaying(_ cell: VideoPostCell)
    func videoDidStopPlaying(_ cell: VideoPostCell)
    func videoDidFailToLoad(_ cell: VideoPostCell, error: Error)
}

class VideoManager: NSObject {
    
    weak var delegate: VideoManagerDelegate?
    
    private var playingCells: Set<VideoPostCell> = []
    private var preloadedPlayers: [URL: AVPlayer] = [:]
    private let maxPreloadedPlayers = 3
    private var isEnabled = true
    
    override init() {
        super.init()
        setupAudioSession()
        setupAppStateObservers()
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to setup audio session: \(error)")
        }
    }
    
    private func setupAppStateObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidEnterBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appWillEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }
    
    @objc private func appDidEnterBackground() {
        pauseAllVideos()
        isEnabled = false
    }
    
    @objc private func appWillEnterForeground() {
        isEnabled = true
    }
    
    @objc private func appDidBecomeActive() {
        isEnabled = true
    }
    
    func updateVisibleCells(_ visibleCells: [VideoPostCell]) {
        guard isEnabled else { return }
        
        let currentlyVisible = Set(visibleCells)
        let currentlyPlaying = playingCells
        
        let cellsToStop = currentlyPlaying.subtracting(currentlyVisible)
        let cellsToPlay = currentlyVisible.subtracting(currentlyPlaying)
        
        for cell in cellsToStop {
            stopVideo(in: cell)
        }
        
        for cell in cellsToPlay {
            playVideo(in: cell)
        }
        
        preloadVideosForUpcomingCells(visibleCells)
    }
    
    private func playVideo(in cell: VideoPostCell) {
        guard let videoURL = cell.videoURL else { return }
        
        if let preloadedPlayer = preloadedPlayers[videoURL] {
            cell.videoPlayer = preloadedPlayer
            setupPlayerLayer(for: cell, player: preloadedPlayer)
            preloadedPlayers.removeValue(forKey: videoURL)
        }
        
        if cell.videoPlayer == nil {
            let playerItem = AVPlayerItem(url: videoURL)
            let player = AVPlayer(playerItem: playerItem)
            player.isMuted = true
            cell.videoPlayer = player
            setupPlayerLayer(for: cell, player: player)
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(playerDidFinishPlaying),
                name: .AVPlayerItemDidPlayToEndTime,
                object: playerItem
            )
        }
        
        cell.playVideo()
        playingCells.insert(cell)
        delegate?.videoDidStartPlaying(cell)
    }
    
    private func setupPlayerLayer(for cell: VideoPostCell, player: AVPlayer) {
        DispatchQueue.main.async {
            cell.videoPlayerLayer?.removeFromSuperlayer()
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.videoGravity = .resizeAspectFill
            playerLayer.frame = cell.videoContainerView.bounds
            cell.videoContainerView.layer.insertSublayer(playerLayer, at: 0)
            cell.videoPlayerLayer = playerLayer
        }
    }
    
    private func stopVideo(in cell: VideoPostCell) {
        cell.pauseVideo()
        playingCells.remove(cell)
        delegate?.videoDidStopPlaying(cell)
    }
    
    @objc private func playerDidFinishPlaying(notification: Notification) {
        guard let playerItem = notification.object as? AVPlayerItem else { return }
        
        for cell in playingCells {
            if cell.videoPlayer?.currentItem == playerItem {
                cell.videoPlayer?.seek(to: .zero)
                cell.videoPlayer?.play()
                break
            }
        }
    }
    
    private func preloadVideosForUpcomingCells(_ visibleCells: [VideoPostCell]) {
        guard preloadedPlayers.count < maxPreloadedPlayers else { return }
        
        let urlsToPreload = visibleCells.compactMap { $0.videoURL }
            .filter { !preloadedPlayers.keys.contains($0) }
            .prefix(maxPreloadedPlayers - preloadedPlayers.count)
        
        for url in urlsToPreload {
            preloadVideoInternal(url: url)
        }
        
        cleanupUnusedPreloadedPlayers(currentURLs: urlsToPreload + visibleCells.compactMap { $0.videoURL })
    }
    
    func preloadVideo(url: URL) {
        guard preloadedPlayers[url] == nil else { return }
        preloadVideoInternal(url: url)
    }
    
    private func preloadVideoInternal(url: URL) {
        let playerItem = AVPlayerItem(url: url)
        let player = AVPlayer(playerItem: playerItem)
        player.isMuted = true
        
        preloadedPlayers[url] = player
        
        player.preroll(atRate: 0) { [weak self] success in
            if !success {
                self?.preloadedPlayers.removeValue(forKey: url)
            }
        }
    }
    
    private func cleanupUnusedPreloadedPlayers(currentURLs: [URL]) {
        let currentURLSet = Set(currentURLs)
        let urlsToRemove = preloadedPlayers.keys.filter { !currentURLSet.contains($0) }
        
        for url in urlsToRemove {
            preloadedPlayers[url]?.pause()
            preloadedPlayers.removeValue(forKey: url)
        }
    }
    
    func pauseAllVideos() {
        for cell in playingCells {
            cell.pauseVideo()
        }
        playingCells.removeAll()
    }
    
    func resumePlayback() {
        isEnabled = true
    }
    
    func cleanupAll() {
        pauseAllVideos()
        
        for player in preloadedPlayers.values {
            player.pause()
        }
        preloadedPlayers.removeAll()
        
        NotificationCenter.default.removeObserver(self)
    }
    
    deinit {
        cleanupAll()
    }
}