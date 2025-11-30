//
//  PostCollection.swift
//  PrimaryDetailSwift
//
//  Created by Steven Zeck on 7/3/24.
//

import Foundation

/// A container that decodes a post collection from the URL.
///
/// This structure decodes JSON with the following layout:
///
/// ```json
/// [
///    {
///       "userId": 1,
///       "id": 1,
///       "title": "Title of the post",
///       "body": "Body of the post"
///    }
/// ]
/// ```
struct PostCollection: Decodable {
    
    // MARK: Properties
    
    /// The user ID associated with the post.
    let userId: Int
    /// The unique identifier of the post.
    let id: Int
    /// The title of the post.
    let title: String
    /// The body content of the post.
    let body: String
}

// MARK: Fetching

extension PostCollection {
    /// Gets and decodes posts from the URL.
    /// - Returns: An array of `PostCollection` objects.
    /// - Throws: `DownloadError` if data is missing or format is wrong.
    static func fetchPosts() async throws -> [PostCollection] {
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!

        let session = URLSession.shared
        guard let (data, response) = try? await session.data(from: url),
              let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200
        else {
            throw DownloadError.missingData
        }

        do {
            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .millisecondsSince1970
            return try jsonDecoder.decode([PostCollection].self, from: data)
        } catch {
            throw DownloadError.wrongDataFormat(error: error)
        }
    }
}

// MARK: Error Handling

/// The kinds of errors that occur when loading posts.
enum DownloadError: Error {
    /// Indicates that the data format is incorrect.
    case wrongDataFormat(error: Error)
    /// Indicates that the data is missing.
    case missingData
}
