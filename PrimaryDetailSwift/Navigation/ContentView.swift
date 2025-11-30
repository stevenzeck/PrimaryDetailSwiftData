//
//  ContentView.swift
//  PrimaryDetailSwift
//
//  Created by Steven Zeck on 7/3/24.
//

import SwiftUI
import SwiftData

/// The main view of the application, displaying a list of posts and their details.
struct ContentView: View {
    
    // MARK: Properties
    
    /// The model context for database operations.
    @Environment(\.modelContext) private var modelContext
    /// The list of posts fetched from the data store.
    @Query private var posts: [Post]
    
    /// The identifier of the currently selected post.
    @State private var selectedId: Post.ID?

    // MARK: Body
    
    /// The content and behavior of the view.
    var body: some View {
        NavigationSplitView {
            // List of posts.
            List(selection: $selectedId) {
                ForEach(posts, id: \.id) { post in
                    NavigationLink {
                        let selectedPost = posts.first(where: { $0.id == selectedId })
                        PostDetail(selectedPost: selectedPost)
                    } label: {
                        Text(post.title)
                    }
                    Text(post.title)
                }
                // Enables swipe-to-delete functionality.
                .onDelete(perform: deleteItems)
            }
            // Adds an edit button on iOS.
            .toolbar {
                #if os(iOS)
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                #endif
            }
            // Enables pull-to-refresh to load new posts.
            .refreshable {
                await PostCollection.refresh(modelContext: modelContext)
            }
            // Sets the title of the list view.
            .navigationTitle("Posts")
        } detail: {
            // The detail view shown when a post is selected.
            let selectedPost = posts.first(where: { $0.id == selectedId })
            PostDetail(selectedPost: selectedPost)
            #if os(macOS)
            .navigationTitle("Post Detail 1")
            #else
            .navigationTitle("Post Detail 1")
            .navigationBarTitleDisplayMode(.inline)
            #endif
        }
    }

    // MARK: Actions
    
    /// Deletes the posts at the specified offsets.
    /// - Parameter offsets: The set of indices to delete.
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(posts[index])
            }
        }
    }
}

// MARK: Preview

/// A preview for the ContentView.
#Preview {
    ContentView()
        .modelContainer(for: Post.self, inMemory: true)
}
