//
//  PrimaryDetailSwiftTests.swift
//  PrimaryDetailSwiftTests
//
//  Created by Steven Zeck on 7/3/24.
//

import Foundation
@testable import PrimaryDetailSwift
import SwiftData
import Testing

@Suite("Post & Persistence Tests")
struct PrimaryDetailSwiftTests {
    @Test("Decodes PostCollection JSON and initializes Post model")
    func decodeAndInitializePost() throws {
        let json = """
        [
            {
                "userId": 1,
                "id": 42,
                "title": "Swift Testing",
                "body": "Testing modern Swift features."
            }
        ]
        """
        let data = try #require(json.data(using: .utf8))
        let decoded = try JSONDecoder().decode([PostCollection].self, from: data)

        #expect(decoded.count == 1)
        let firstItem = try #require(decoded.first)

        let post = Post(from: firstItem)
        #expect(post.id == 42)
        #expect(post.userId == 1)
        #expect(post.title == "Swift Testing")
        #expect(post.body == "Testing modern Swift features.")
        #expect(!post.read)
    }

    @Test("Enforces #Unique constraint on Post.id in SwiftData")
    @MainActor
    func uniquePostConstraint() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Post.self, configurations: config)
        let context = container.mainContext

        let original = Post(id: 1, userId: 1, title: "Original Title", body: "Original Body", read: false)
        let updated = Post(id: 1, userId: 1, title: "Updated Title", body: "Updated Body", read: true)

        context.insert(original)
        context.insert(updated)
        try context.save()

        let fetched = try context.fetch(FetchDescriptor<Post>())
        #expect(fetched.count == 1)
        #expect(fetched.first?.title == "Updated Title")
        #expect(fetched.first?.read == true)
    }
}
