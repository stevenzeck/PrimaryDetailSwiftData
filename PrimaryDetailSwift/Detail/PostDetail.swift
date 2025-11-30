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
        ScrollView {
            if let post = selectedPost {
                Text(post.title)
                    .font(.title)
                Text(post.body)
                    .font(.body)
            } else {
                Text("Select a post to view details")
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
    }
}
