//
//  PostModel.swift
//  fakefb
//
//  Created by Claude on 19/09/2025.
//

import UIKit
import Foundation

enum PostType {
    case text
    case image
    case video
}

struct CommentModel {
    let id: String
    let author: String
    let avatar: String
    let content: String
    let timeAgo: String
    let likes: Int
}

struct PostModel {
    let id: String
    let type: PostType
    let username: String
    let timeAgo: String
    let content: String
    let profileImage: UIImage?
    let image: UIImage?
    let videoURL: URL?
    let likes: Int
    let comments: Int
    let shares: Int
    let commentList: [CommentModel]
    
    init(id: String, type: PostType, username: String, timeAgo: String, content: String, profileImage: UIImage? = nil, image: UIImage? = nil, videoURL: URL? = nil, likes: Int = 0, comments: Int = 0, shares: Int = 0, commentList: [CommentModel] = []) {
        self.id = id
        self.type = type
        self.username = username
        self.timeAgo = timeAgo
        self.content = content
        self.profileImage = profileImage
        self.image = image
        self.videoURL = videoURL
        self.likes = likes
        self.comments = comments
        self.shares = shares
        self.commentList = commentList
    }
}