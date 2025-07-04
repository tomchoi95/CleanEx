import Foundation
import SwiftUI

struct Category {
    let id: UUID
    var name: String
    var color: CategoryColor
    var icon: String
    let createdAt: Date
    var updatedAt: Date
    
    init(
        id: UUID = UUID(),
        name: String,
        color: CategoryColor = .blue,
        icon: String = "folder",
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.color = color
        self.icon = icon
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

enum CategoryColor: String, CaseIterable {
    case red = "red"
    case orange = "orange"
    case yellow = "yellow"
    case green = "green"
    case blue = "blue"
    case purple = "purple"
    case pink = "pink"
    case gray = "gray"
    
    var color: Color {
        switch self {
        case .red: return .red
        case .orange: return .orange
        case .yellow: return .yellow
        case .green: return .green
        case .blue: return .blue
        case .purple: return .purple
        case .pink: return .pink
        case .gray: return .gray
        }
    }
    
    var displayName: String {
        switch self {
        case .red: return "빨강"
        case .orange: return "주황"
        case .yellow: return "노랑"
        case .green: return "초록"
        case .blue: return "파랑"
        case .purple: return "보라"
        case .pink: return "분홍"
        case .gray: return "회색"
        }
    }
}

// 기본 카테고리들
extension Category {
    static let defaultCategories: [Category] = [
        Category(name: "일반", color: .blue, icon: "folder"),
        Category(name: "업무", color: .orange, icon: "briefcase"),
        Category(name: "개인", color: .green, icon: "person"),
        Category(name: "쇼핑", color: .purple, icon: "cart"),
        Category(name: "건강", color: .red, icon: "heart")
    ]
}