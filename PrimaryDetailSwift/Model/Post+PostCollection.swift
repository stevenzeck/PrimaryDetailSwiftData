//
//  Post+PostCollection.swift
//  PrimaryDetailSwift
//
//  Created by Steven Zeck on 7/3/24.
//

import SwiftData
import OSLog

// MARK: Initialization

extension Post {
    /// Creates a new post instance from a decoded collection item.
    /// - Parameter postCollection: The data source for the post.
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

// MARK: Data Loading

extension PostCollection {
    /// A logger for debugging purposes.
    fileprivate static let logger = Logger(subsystem: "com.example.PrimaryDetailSwift", category: "parsing")

    /// Loads new posts from the server and updates the model context.
    /// - Parameter modelContext: The context where post data is stored.
    @MainActor
    static func refresh(modelContext: ModelContext) async {
        do {
            logger.debug("Refreshing the data store...")
            let postCollection = try await fetchPosts()
            logger.debug("Loaded posts.")

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
