//
//  FeedDataSource.swift
//  fakefb
//
//  Created by Claude on 19/09/2025.
//

import UIKit

class FeedDataSource: NSObject, UITableViewDataSource, UITableViewDataSourcePrefetching {
    
    var videoManager: VideoManager?
    private var posts: [PostModel] = []
    
    override init() {
        super.init()
        generateMockData()
    }
    
    private func generateMockData() {
        let usernames = ["john_doe", "sarah_smith", "mike_jones", "emma_wilson", "alex_brown", "lisa_davis", "tom_miller", "anna_garcia", "david_taylor", "maria_lopez"]
        let timeStamps = ["2m", "5m", "12m", "25m", "1h", "2h", "3h", "5h", "8h", "1d"]
        
        let textContents = [
            "Just finished a great workout at the gym! 💪 Feeling energized and ready to tackle the day.",
            "Beautiful sunset today. Sometimes you just need to stop and appreciate the simple things in life.",
            "Working on a new project that I'm really excited about. Can't wait to share more details soon!",
            "Had an amazing dinner at that new restaurant downtown. The pasta was incredible!",
            "Reading a fascinating book about space exploration. The universe is truly mind-blowing.",
            "Coffee and good music - perfect combination for a productive morning.",
            "Throwback to last summer's vacation. Already planning the next adventure!",
            "Just adopted a rescue puppy! He's already stolen my heart ❤️",
            "Learning to play guitar has been challenging but so rewarding. Practice makes perfect!",
            "Grateful for amazing friends and family. Feeling blessed today."
        ]
        
        let imageContents = [
            "Check out this amazing street art I found during my walk today!",
            "Homemade pizza night was a success! 🍕",
            "Nature photography from this weekend's hiking trip.",
            "My garden is finally blooming! Spring is here 🌸",
            "New artwork I picked up from a local artist. Love supporting the community!",
            "Cozy reading corner setup complete. Time for some weekend relaxation.",
            "Fresh produce from the farmer's market. Cooking something special tonight!",
            "City skyline looking incredible from this rooftop view.",
            "Beach day vibes. Sand, sun, and good times!",
            "Morning coffee with a view. Perfect way to start the day."
        ]
        
        let videoContents = [
            "Trying out some new dance moves I learned online!",
            "Time-lapse of today's cooking adventure in the kitchen.",
            "Quick workout routine you can do anywhere - no equipment needed!",
            "Behind the scenes of my latest art project.",
            "Morning routine that keeps me productive all day.",
            "Playing around with some new music I've been working on.",
            "Fun day at the park with friends playing frisbee.",
            "Exploring the city on my bike - found some cool hidden spots!",
            "Late night coding session with some good vibes.",
            "Teaching my dog some new tricks - he's such a quick learner!"
        ]
        
        for i in 0..<30 {
            let randomType = Int.random(in: 0...2)
            let username = usernames[i % usernames.count]
            let timeAgo = timeStamps[i % timeStamps.count]
            let id = "post_\(i)"
            
            let post: PostModel
            
            switch randomType {
            case 0:
                let content = textContents[i % textContents.count]
                post = PostModel(id: id, type: .text, username: username, timeAgo: timeAgo, content: content)
                
            case 1:
                let content = imageContents[i % imageContents.count]
                let placeholderImage = createPlaceholderImage(width: 300, height: 250, text: "Image \(i + 1)")
                post = PostModel(id: id, type: .image, username: username, timeAgo: timeAgo, content: content, image: placeholderImage)
                
            default:
                let content = videoContents[i % videoContents.count]
                let videoURL = createMockVideoURL(index: i % 5)
                post = PostModel(id: id, type: .video, username: username, timeAgo: timeAgo, content: content, videoURL: videoURL)
            }
            
            posts.append(post)
        }
    }
    
    private func createPlaceholderImage(width: Int, height: Int, text: String) -> UIImage {
        let size = CGSize(width: width, height: height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        let context = UIGraphicsGetCurrentContext()!
        
        let colors = [UIColor.systemBlue, UIColor.systemGreen, UIColor.systemOrange, UIColor.systemPurple, UIColor.systemRed]
        let color = colors.randomElement() ?? UIColor.systemBlue
        
        context.setFillColor(color.cgColor)
        context.fill(CGRect(origin: .zero, size: size))
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16, weight: .medium),
            .foregroundColor: UIColor.white
        ]
        
        let textSize = text.size(withAttributes: attributes)
        let textRect = CGRect(
            x: (size.width - textSize.width) / 2,
            y: (size.height - textSize.height) / 2,
            width: textSize.width,
            height: textSize.height
        )
        
        text.draw(in: textRect, withAttributes: attributes)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image ?? UIImage()
    }
    
    private func createMockVideoURL(index: Int) -> URL? {
        let videoNames = ["sample_video_1", "sample_video_2", "sample_video_3", "sample_video_4", "sample_video_5"]
        let videoName = videoNames[index]
        return Bundle.main.url(forResource: videoName, withExtension: "mp4")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        
        switch post.type {
        case .text:
            let cell = tableView.dequeueReusableCell(withIdentifier: TextPostCell.identifier, for: indexPath) as! TextPostCell
            cell.configure(with: post)
            return cell
            
        case .image:
            let cell = tableView.dequeueReusableCell(withIdentifier: ImagePostCell.identifier, for: indexPath) as! ImagePostCell
            cell.configure(with: post)
            return cell
            
        case .video:
            let cell = tableView.dequeueReusableCell(withIdentifier: VideoPostCell.identifier, for: indexPath) as! VideoPostCell
            cell.videoManager = videoManager
            cell.configure(with: post)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            let post = posts[indexPath.row]
            
            if post.type == .video, let videoURL = post.videoURL {
                videoManager?.preloadVideo(url: videoURL)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        
    }
}