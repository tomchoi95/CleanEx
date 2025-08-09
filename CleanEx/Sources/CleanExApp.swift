//
//  CleanExApp.swift
//  CleanEx
//
//  Created by 최범수 on 2025-04-23.
//

import SwiftUI
import SwiftData
import Presentation
import DI
import Data

@main
struct CleanExApp: App {
    let container = DIContainer.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(container)
        }
        .modelContainer(for: [TodoLocalModel.self]) { result in
            if case .success(let modelContainer) = result {
                container.configure(with: modelContainer.mainContext)
            }
        }
    }
}
