//
//  Post+PostCollection.swift
//  PrimaryDetailSwift
//
//  Created by Steven Zeck on 7/3/24.
//

import SwiftData
import OSLog

// A mapping from posts from the URL to post items.
extension Post {
    /// Creates a new quake instance from a decoded feature.
    convenience init(from postCollection: PostCollection) {
        self.init(
            id: postCollection.id,
            userId: postCollection.userId,
            title: postCollection.title,
            body: postCollection.body,
            read: false
        )
    }
}

// Helper methods for loading post data from the URL and storing it as a post in the app.
extension PostCollection {
    /// A logger for debugging.
    fileprivate static let logger = Logger(subsystem: "com.example.PrimaryDetailSwift", category: "parsing")

    /// Loads new posts.
    @MainActor
    static func refresh(modelContext: ModelContext) async {
        do {
            // Fetch posts from the URL.
            logger.debug("Refreshing the data store...")
            let postCollection = try await fetchPosts()
            logger.debug("Loaded posts.")

            // Add the content to the data store.
            for serverPost in postCollection {
                let post = Post(from: serverPost)

                logger.debug("Inserting post.")
                modelContext.insert(post)
            }

            logger.debug("Refresh complete.")

        } catch let error {
            logger.error("\(error.localizedDescription)")
        }
    }
}
