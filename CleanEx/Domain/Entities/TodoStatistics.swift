import Foundation

struct TodoStatistics {
    let totalTodos: Int
    let completedTodos: Int
    let pendingTodos: Int
    let todayTodos: Int
    let overdueTodos: Int
    let priorityBreakdown: [TodoPriority: Int]
    let categoryBreakdown: [UUID: Int]
    let completionRate: Double
    let averageCompletionTime: TimeInterval?
    let streakDays: Int
    
    init(
        totalTodos: Int = 0,
        completedTodos: Int = 0,
        pendingTodos: Int = 0,
        todayTodos: Int = 0,
        overdueTodos: Int = 0,
        priorityBreakdown: [TodoPriority: Int] = [:],
        categoryBreakdown: [UUID: Int] = [:],
        completionRate: Double = 0.0,
        averageCompletionTime: TimeInterval? = nil,
        streakDays: Int = 0
    ) {
        self.totalTodos = totalTodos
        self.completedTodos = completedTodos
        self.pendingTodos = pendingTodos
        self.todayTodos = todayTodos
        self.overdueTodos = overdueTodos
        self.priorityBreakdown = priorityBreakdown
        self.categoryBreakdown = categoryBreakdown
        self.completionRate = completionRate
        self.averageCompletionTime = averageCompletionTime
        self.streakDays = streakDays
    }
    
    static func calculate(from todos: [Todo]) -> TodoStatistics {
        let totalTodos = todos.count
        let completedTodos = todos.filter { $0.isCompleted }.count
        let pendingTodos = totalTodos - completedTodos
        
        let today = Calendar.current.startOfDay(for: Date())
        let todayTodos = todos.filter { Calendar.current.isDate($0.createdAt, inSameDayAs: today) }.count
        
        // 우선순위별 분포
        var priorityBreakdown: [TodoPriority: Int] = [:]
        for priority in TodoPriority.allCases {
            priorityBreakdown[priority] = todos.filter { $0.priority == priority }.count
        }
        
        // 카테고리별 분포
        var categoryBreakdown: [UUID: Int] = [:]
        for todo in todos {
            if let categoryId = todo.categoryId {
                categoryBreakdown[categoryId, default: 0] += 1
            }
        }
        
        // 완료율 계산
        let completionRate = totalTodos > 0 ? Double(completedTodos) / Double(totalTodos) : 0.0
        
        // 평균 완료 시간 계산 (생성일부터 완료일까지)
        let completedTodosWithTime = todos.filter { $0.isCompleted }
        let averageCompletionTime: TimeInterval? = !completedTodosWithTime.isEmpty ?
            completedTodosWithTime.map { $0.updatedAt.timeIntervalSince($0.createdAt) }
                .reduce(0, +) / Double(completedTodosWithTime.count) : nil
        
        return TodoStatistics(
            totalTodos: totalTodos,
            completedTodos: completedTodos,
            pendingTodos: pendingTodos,
            todayTodos: todayTodos,
            overdueTodos: 0, // 추후 due date 기능 추가 시 구현
            priorityBreakdown: priorityBreakdown,
            categoryBreakdown: categoryBreakdown,
            completionRate: completionRate,
            averageCompletionTime: averageCompletionTime,
            streakDays: 0 // 추후 구현
        )
    }
}

extension TodoStatistics {
    var formattedCompletionRate: String {
        return String(format: "%.1f%%", completionRate * 100)
    }
    
    var formattedAverageCompletionTime: String {
        guard let averageTime = averageCompletionTime else {
            return "데이터 없음"
        }
        
        let hours = Int(averageTime) / 3600
        let minutes = Int(averageTime) % 3600 / 60
        
        if hours > 0 {
            return "\(hours)시간 \(minutes)분"
        } else {
            return "\(minutes)분"
        }
    }
}