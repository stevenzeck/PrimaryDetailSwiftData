//
//  PostDetail.swift
//  PrimaryDetailSwift
//
//  Created by Steven Zeck on 7/3/24.
//

import SwiftData
import SwiftUI

struct PostDetail: View {
    let selectedPost: Post?
    
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
        .navigationTitle("Post Detail 2")
        #else
        .navigationTitle("Post Detail 2")
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}
