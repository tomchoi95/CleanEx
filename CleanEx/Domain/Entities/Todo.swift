//
//  Todo.swift
//  CleanEx
//
//  Created by 최범수 on 2025-04-23.
//

import Foundation

struct Todo {
    let id: UUID
    let title: String
    let description: String?
    let isCompleted: Bool
    let createdAt: Date
    let updatedAt: Date
    
    init(
        title: String,
        description: String? = nil,
        isCompleted: Bool = false,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = UUID()
        self.title = title
        self.description = description
        self.isCompleted = isCompleted
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

// description is optional
