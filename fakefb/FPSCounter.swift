//
//  FPSCounter.swift
//  fakefb
//
//  Created by Claude on 19/09/2025.
//

import UIKit
import QuartzCore

class FPSCounter: UIView {
    
    private let label = UILabel()
    private var displayLink: CADisplayLink?
    private var lastTimestamp: CFTimeInterval = 0
    private var frameCount = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        startDisplayLink()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        startDisplayLink()
    }
    
    private func setupUI() {
        backgroundColor = UIColor.black.withAlphaComponent(0.7)
        layer.cornerRadius = 8
        clipsToBounds = true
        
        label.textColor = .white
        label.font = UIFont.monospacedSystemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.text = "-- FPS"
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 4),
            label.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -4)
        ])
    }
    
    private func startDisplayLink() {
        displayLink = CADisplayLink(target: self, selector: #selector(displayLinkTick))
        displayLink?.add(to: .main, forMode: .common)
    }
    
    @objc private func displayLinkTick(displayLink: CADisplayLink) {
        if lastTimestamp == 0 {
            lastTimestamp = displayLink.timestamp
            return
        }
        
        frameCount += 1
        
        let elapsed = displayLink.timestamp - lastTimestamp
        
        if elapsed >= 1.0 {
            let fps = Double(frameCount) / elapsed
            
            DispatchQueue.main.async { [weak self] in
                self?.label.text = String(format: "%.0f FPS", fps)
                
                if fps >= 58 {
                    self?.label.textColor = .systemGreen
                } else if fps >= 45 {
                    self?.label.textColor = .systemYellow
                } else {
                    self?.label.textColor = .systemRed
                }
            }
            
            frameCount = 0
            lastTimestamp = displayLink.timestamp
        }
    }
    
    func stop() {
        displayLink?.invalidate()
        displayLink = nil
    }
    
    deinit {
        stop()
    }
}