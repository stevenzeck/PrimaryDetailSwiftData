//
//  PostDetail.swift
//  PrimaryDetailSwift
//
//  Created by Steven Zeck on 7/3/24.
//

import SwiftData
import SwiftUI

/// A view that displays the details of a specific post.
struct PostDetail: View {
    // MARK: Properties

    /// The post to display details for.
    let selectedPost: Post?

    // MARK: Body

    /// The content and behavior of the view.
    var body: some View {
        Group {
            if let post = selectedPost {
                ScrollView {
                    Text(post.title)
                        .font(.title)
                    Text(post.body)
                        .font(.body)
                }
            } else {
                ContentUnavailableView(
                    "Select a Post",
                    systemImage: "doc.text",
                    description: Text("Select a post to view details")
                )
            }
        }
        #if os(macOS)
        // Sets the navigation title for macOS.
        .navigationTitle("Post Detail 2")
        #else
        // Sets the navigation title for iOS.
        .navigationTitle("Post Detail 2")
        // Sets the title display mode to inline.
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .onChange(of: selectedPost, initial: true) { _, newPost in
            if let newPost, !newPost.read {
                newPost.read = true
            }
        }
    }
}

// MARK: Preview

// A preview for the PostDetail view.
#Preview {
    PostDetail(
        selectedPost: Post(
            id: 1,
            userId: 1,
            title: "Sample Post Title",
            body: "Sample post body content.",
            read: false
        )
    )
    .modelContainer(for: Post.self, inMemory: true)
}
