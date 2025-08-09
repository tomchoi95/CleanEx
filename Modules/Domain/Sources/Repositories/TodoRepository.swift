import Foundation

/// 할 일 데이터에 대한 접근을 정의하는 인터페이스
public protocol TodoRepository {
    /// 모든 할 일 목록을 가져옵니다.
    /// - Returns: 할 일 목록
    /// - Throws: 데이터 접근 중 발생한 에러
    func getAllTodos() async throws -> [Todo]
    
    /// 특정 ID의 할 일을 가져옵니다.
    /// - Parameter id: 할 일의 고유 식별자
    /// - Returns: 해당 ID의 할 일
    /// - Throws: 데이터 접근 중 발생한 에러
    func getTodo(id: UUID) async throws -> Todo
    
    /// 새로운 할 일을 생성합니다.
    /// - Parameter todo: 생성할 할 일
    /// - Returns: 생성된 할 일
    /// - Throws: 데이터 접근 중 발생한 에러
    func addTodo(todo: Todo) async throws -> Todo
    
    /// 기존 할 일을 수정합니다.
    /// - Parameter todo: 수정할 할 일
    /// - Returns: 수정된 할 일
    /// - Throws: 데이터 접근 중 발생한 에러
    func updateTodo(todo: Todo) async throws -> Todo
    
    /// 할 일을 삭제합니다.
    /// - Parameter id: 삭제할 할 일의 고유 식별자
    /// - Throws: 데이터 접근 중 발생한 에러
    func deleteTodo(id: UUID) async throws -> Void
}
