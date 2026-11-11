//
//  ContentView.swift
//  PrimaryDetailSwift
//
//  Created by Steven Zeck on 7/3/24.
//

import SwiftData
import SwiftUI

/// The main view of the application, displaying a list of posts and their details.
struct ContentView: View {
    // MARK: Properties

    /// The model context for database operations.
    @Environment(\.modelContext) private var modelContext
    /// The list of posts fetched from the data store.
    @Query private var posts: [Post]

    /// The currently selected posts (supports both single navigation selection and multi-selection in Edit mode).
    @State private var selectedPosts: Set<Post> = []
    #if os(iOS)
        /// The current edit mode of the list on iOS.
        @State private var editMode: EditMode = .inactive
    #endif

    // MARK: Body

    /// The content and behavior of the view.
    var body: some View {
        NavigationSplitView {
            // List of posts.
            List(selection: $selectedPosts) {
                ForEach(posts, id: \.self) { post in
                    NavigationLink(value: post) {
                        Text(post.title)
                            .fontWeight(post.read ? .regular : .bold)
                    }
                }
                // Enables swipe-to-delete functionality.
                .onDelete(perform: deleteItems)
            }
            .overlay {
                if posts.isEmpty {
                    ContentUnavailableView(
                        "No Posts",
                        systemImage: "tray",
                        description: Text("Pull to refresh to load posts.")
                    )
                }
            }
            // Adds an edit button on iOS and a batch delete button when editing.
            .toolbar {
                #if os(iOS)
                    ToolbarItem(placement: .navigationBarLeading) {
                        EditButton()
                    }
                    if editMode.isEditing, !selectedPosts.isEmpty {
                        ToolbarItem(placement: .primaryAction) {
                            Button(role: .destructive, action: deleteSelectedPosts) {
                                Label("Delete Selected", systemImage: "trash")
                            }
                        }
                    }
                #else
                    if !selectedPosts.isEmpty {
                        ToolbarItem(placement: .primaryAction) {
                            Button(role: .destructive, action: deleteSelectedPosts) {
                                Label("Delete Selected", systemImage: "trash")
                            }
                        }
                    }
                #endif
            }
            #if os(iOS)
            .environment(\.editMode, $editMode)
            .onChange(of: editMode) { _, _ in
                selectedPosts.removeAll()
            }
            #endif
            #if os(macOS)
            .onDeleteCommand(perform: deleteSelectedPosts)
            #endif
            // Enables pull-to-refresh to load new posts.
            .refreshable {
                await PostCollection.refresh(modelContainer: modelContext.container)
            }
            // Sets the title of the list view.
            .navigationTitle("Posts")
        } detail: {
            // The detail view shown when a single post is selected.
            PostDetail(selectedPost: selectedPosts.count == 1 ? selectedPosts.first : nil)
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
                let postToDelete = posts[index]
                selectedPosts.remove(postToDelete)
                modelContext.delete(postToDelete)
            }
        }
    }

    /// Deletes all currently selected posts.
    private func deleteSelectedPosts() {
        withAnimation {
            for post in selectedPosts {
                modelContext.delete(post)
            }
            selectedPosts.removeAll()
        }
    }
}

// MARK: Preview

// A preview for the ContentView.
#Preview {
    ContentView()
        .modelContainer(for: Post.self, inMemory: true)
}
