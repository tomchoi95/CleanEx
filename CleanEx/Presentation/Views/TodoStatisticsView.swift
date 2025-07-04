import SwiftUI

struct TodoStatisticsView: View {
    let statistics: TodoStatistics
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 20) {
                    // 헤더 통계 카드들
                    headerStatsView
                    
                    // 완료율 차트
                    completionRateView
                    
                    // 우선순위별 분포
                    priorityBreakdownView
                    
                    // 카테고리별 분포 (카테고리가 있는 경우만)
                    if !statistics.categoryBreakdown.isEmpty {
                        categoryBreakdownView
                    }
                    
                    // 추가 정보
                    additionalInfoView
                }
                .padding()
            }
            .navigationTitle("할 일 통계")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("완료") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var headerStatsView: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
            StatCard(
                title: "전체 할 일",
                value: "\(statistics.totalTodos)",
                icon: "list.bullet",
                color: .blue
            )
            
            StatCard(
                title: "완료된 할 일",
                value: "\(statistics.completedTodos)",
                icon: "checkmark.circle.fill",
                color: .green
            )
            
            StatCard(
                title: "진행 중인 할 일",
                value: "\(statistics.pendingTodos)",
                icon: "clock",
                color: .orange
            )
            
            StatCard(
                title: "오늘 생성된 할 일",
                value: "\(statistics.todayTodos)",
                icon: "calendar",
                color: .purple
            )
        }
    }
    
    private var completionRateView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("완료율")
                .font(.headline)
                .foregroundColor(.primary)
            
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 12)
                    .frame(width: 120, height: 120)
                
                Circle()
                    .trim(from: 0, to: statistics.completionRate)
                    .stroke(
                        LinearGradient(
                            colors: [.blue, .green],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 12, lineCap: .round)
                    )
                    .frame(width: 120, height: 120)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 1.0), value: statistics.completionRate)
                
                VStack {
                    Text(statistics.formattedCompletionRate)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    Text("완료")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private var priorityBreakdownView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("우선순위별 분포")
                .font(.headline)
                .foregroundColor(.primary)
            
            ForEach(TodoPriority.allCases, id: \.self) { priority in
                let count = statistics.priorityBreakdown[priority] ?? 0
                
                HStack {
                    Image(systemName: priority.icon)
                        .foregroundColor(Color(priority.color))
                        .frame(width: 20)
                    
                    Text(priority.displayName)
                        .font(.body)
                    
                    Spacer()
                    
                    Text("\(count)개")
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private var categoryBreakdownView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("카테고리별 분포")
                .font(.headline)
                .foregroundColor(.primary)
            
            ForEach(Array(statistics.categoryBreakdown.keys), id: \.self) { categoryId in
                let count = statistics.categoryBreakdown[categoryId] ?? 0
                
                HStack {
                    Image(systemName: "folder.fill")
                        .foregroundColor(.blue)
                        .frame(width: 20)
                    
                    Text("카테고리")
                        .font(.body)
                    
                    Spacer()
                    
                    Text("\(count)개")
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private var additionalInfoView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("추가 정보")
                .font(.headline)
                .foregroundColor(.primary)
            
            InfoDetailRow(
                title: "평균 완료 시간",
                value: statistics.formattedAverageCompletionTime,
                icon: "clock"
            )
            
            InfoDetailRow(
                title: "연속 달성 일수",
                value: "\(statistics.streakDays)일",
                icon: "flame"
            )
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct InfoDetailRow: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 20)
            
            Text(title)
                .font(.body)
            
            Spacer()
            
            Text(value)
                .font(.body)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    TodoStatisticsView(
        statistics: TodoStatistics(
            totalTodos: 15,
            completedTodos: 10,
            pendingTodos: 5,
            todayTodos: 3,
            overdueTodos: 1,
            priorityBreakdown: [.high: 5, .medium: 7, .low: 3],
            categoryBreakdown: [:],
            completionRate: 0.67,
            averageCompletionTime: 3600 * 2.5,
            streakDays: 5
        )
    )
}