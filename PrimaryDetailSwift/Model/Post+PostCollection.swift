//
//  Post+PostCollection.swift
//  PrimaryDetailSwift
//
//  Created by Steven Zeck on 7/3/24.
//

import OSLog
import SwiftData

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

/// A background model actor that fetches and persists posts off the main actor.
@ModelActor
actor PostDataHandler {
    /// A logger for debugging purposes.
    fileprivate static let logger = Logger(subsystem: "com.example.PrimaryDetailSwift", category: "parsing")

    /// Loads new posts from the server and updates the actor's model context.
    func refresh() async {
        let postCollection: [PostCollection]
        do {
            Self.logger.debug("Refreshing the data store...")
            postCollection = try await PostCollection.fetchPosts()
            Self.logger.debug("Loaded posts.")
        } catch {
            switch error {
            case .missingData:
                Self.logger.error("Failed to refresh posts: missing data from server.")
            case let .wrongDataFormat(underlyingError):
                Self.logger.error("Failed to decode posts: \(underlyingError.localizedDescription)")
            }
            return
        }

        for serverPost in postCollection {
            let post = Post(from: serverPost)

            Self.logger.debug("Inserting post.")
            modelContext.insert(post)
        }

        do {
            try modelContext.save()
            Self.logger.debug("Refresh complete.")
        } catch {
            Self.logger.error("Failed to save posts: \(error.localizedDescription)")
        }
    }
}

extension PostCollection {
    /// Loads new posts from the server and updates the model container on a background actor.
    /// - Parameter modelContainer: The container where post data is stored.
    @concurrent
    static func refresh(modelContainer: ModelContainer) async {
        let handler = PostDataHandler(modelContainer: modelContainer)
        await handler.refresh()
    }
}
