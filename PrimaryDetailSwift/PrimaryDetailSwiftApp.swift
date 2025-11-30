//
//  PrimaryDetailSwiftApp.swift
//  PrimaryDetailSwift
//
//  Created by Steven Zeck on 7/3/24.
//

import SwiftUI
import SwiftData

/// The main entry point for the PrimaryDetailSwift application.
@main
struct PrimaryDetailSwiftApp: App {
    
    // MARK: Properties
    
    /// The shared model container for managing data persistence.
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Post.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    // MARK: Body
    
    /// The scene that contains the app's window group.
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
