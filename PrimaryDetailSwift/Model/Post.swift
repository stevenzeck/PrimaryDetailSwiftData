//
//  Post.swift
//  PrimaryDetailSwift
//
//  Created by Steven Zeck on 7/3/24.
//

import Foundation
import SwiftData

/// A model representing a post.
@Model class Post {
    
    // MARK: Properties
    
    /// A unique identifier associated with each post.
    @Attribute(.unique) var id: Int = 0
    /// The user ID of the post.
    var userId: Int = 0
    /// The title of the post.
    var title: String
    /// The body of the post.
    var body: String
    /// Whether the post has been read or not.
    var read: Bool
    
    // MARK: Initialization
    
    /// Initializes a new Post instance.
    /// - Parameters:
    ///   - id: The unique identifier.
    ///   - userId: The user ID.
    ///   - title: The post title.
    ///   - body: The post body.
    ///   - read: The read status.
    init(id: Int, userId: Int, title: String, body: String, read: Bool) {
        self.id = id
        self.userId = userId
        self.title = title
        self.body = body
        self.read = read
    }
}

// MARK: Identifiable

/// Conforms Post to the Identifiable protocol.
extension Post: Identifiable {}
