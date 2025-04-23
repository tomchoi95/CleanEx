//
//  TodoRepository.swift
//  CleanEx
//
//  Created by 최범수 on 2025-04-23.
//

import Foundation

protocol TodoRepository {
    func getAllTodos() async throws -> [Todo]
    func getTodo(id: UUID) async throws -> Todo
    func createTodo(_ todo: Todo) async throws
    func updateTodo(_ todo: Todo) async throws
    func deleteTodo(id: UUID) async throws
}

// 모든 메서드는 비동기 처리를 위해서. async 키워드를 가져야 함.
// The reason is it could be heavy work?
// method name should be neat and clear
// throws를 하게 하지 않았음. 해야하는 이유를 잘 모르겠다.
/*

 해야 하는 이유.
 MARK: 1. 데이터의 일관성 보장
    예를 들어 getTodo method를 호출시. nil 이 반환될 수 있음
    하지만 이는 명확한 이유를 설명하지 못하고, 결과만 뱉을 뿐.
    명확한 실패한 근거를 제시하고 그에대한 해결 방안을 도출 해 내려면 에러를 통하여 호출한 친구에게 명확한 의사를 전달해야 함.
    * 현재: nil을 반환
    * 문제점: 호출하는 쪽에서 nil이 '찾지 못함'인지 '에러 발생'인지 구분할 수 없음
    * 해결: throws를 사용하면 명확하게 '찾지 못함'이라는 에러를 던질 수 있음
    * 궁금증: 그러면 nil을 반환 할 필요가 없잔아...? -> 응 그러니까 nil말고 명확하게 에러 핸들링 하자!
 
 MARK: 2. 명확한 에러 전파.
 
 // 현재 코드
 func getTodo(id: UUID) async -> Todo? {
     // 데이터베이스 연결 실패
     // 네트워크 오류
     // 권한 없음
     // 등등...
     return nil  // 어떤 문제가 발생했는지 알 수 없음
 }

 // throws를 사용한 코드
 func getTodo(id: UUID) async throws -> Todo {
     // 데이터베이스 연결 실패 -> DatabaseError
     // 네트워크 오류 -> NetworkError
     // 권한 없음 -> AuthorizationError
     // 등등...
     throw SpecificError  // 정확한 에러 타입을 전파
 }
 
 MARK: 3. 에러 복구 가능성.
 
 // 현재 코드
 if let todo = await repository.getTodo(id: id) {
     // 성공
 } else {
     // 실패 - 하지만 왜 실패했는지 모름
 }

 // throws를 사용한 코드
 do {
     let todo = try await repository.getTodo(id: id)
     // 성공
 } catch DatabaseError.connectionFailed {
     // 데이터베이스 연결 실패 - 재시도 로직
 } catch NetworkError.timeout {
     // 네트워크 타임아웃 - 재시도 로직
 } catch {
     // 기타 에러 처리
 }
 
 MARK: 4. 테스트 용이성
 
 // 현재 코드
 func testGetTodo() {
    // nil이 반환되는 경우가 여러가지라 테스트하기 어려움.
 }
 
 func testGetTodo() throws {
    // 특정 에러가 발생하는 경우를 명확하게 테스트 가능.
    XCTAssertThrowsError(try await repository.getTodo(id: invalidId) { error in
        XCTAssertEqual(error as? TodoError, .notFound)
    }
 }
 
 MARK: 5. 클린 아키텍쳐 원칙 준수.
 
    * 도메인 레이어는 비즈니스 로직의 실패를 명확하게 표현해야 함.
    * 에러는 비즈니스 로직의 일부로 간주되어야 함.
    * throws를 사용하면 에러를 명시적인 비즈니스 로직의 일부로 처리할 수 있음.
 */
