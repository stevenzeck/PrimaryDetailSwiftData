//
//  ContentView.swift
//  PrimaryDetailSwift
//
//  Created by Steven Zeck on 7/3/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var posts: [Post]
    
    @State private var selectedId: Post.ID?

    var body: some View {
        NavigationSplitView {
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
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                #if os(iOS)
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                #endif
            }
            .refreshable {
                await PostCollection.refresh(modelContext: modelContext)
            }
            .navigationTitle("Posts")
        } detail: {
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

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(posts[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Post.self, inMemory: true)
}
