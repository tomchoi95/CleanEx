//
//  CleanExApp.swift
//  CleanEx
//
//  Created by 최범수 on 2025-04-23.
//

import SwiftUI
import SwiftData

@main
struct CleanExApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [TodoLocalModel.self])
    }
}
