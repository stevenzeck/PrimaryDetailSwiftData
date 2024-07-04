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
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

// Fetch new posts.
extension PostCollection {
    /// Gets and decodes posts from the URL.
    static func fetchPosts() async throws -> [PostCollection] {
        /// Sample JSON
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!

        let session = URLSession.shared
        guard let (data, response) = try? await session.data(from: url),
              let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200
        else {
            throw DownloadError.missingData
        }

        do {
            // Decode the JSON into a data model.
            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .millisecondsSince1970
            return try jsonDecoder.decode([PostCollection].self, from: data)
        } catch {
            throw DownloadError.wrongDataFormat(error: error)
        }
    }
}

/// The kinds of errors that occur when loading posts.
enum DownloadError: Error {
    case wrongDataFormat(error: Error)
    case missingData
}
