`Domain/UseCases` 폴더를 생성하고, 그 안에 `TodoUseCase.swift` 파일을 만들어보겠습니다.

UseCase는 비즈니스 로직을 캡슐화하는 역할을 합니다. 다음과 같은 UseCase들을 구현해보겠습니다:

1. `GetAllTodosUseCase`: 모든 할 일 목록을 가져오는 UseCase
2. `GetTodoUseCase`: 특정 할 일을 가져오는 UseCase
3. `CreateTodoUseCase`: 새로운 할 일을 생성하는 UseCase
4. `UpdateTodoUseCase`: 기존 할 일을 수정하는 UseCase
5. `DeleteTodoUseCase`: 할 일을 삭제하는 UseCase

먼저 `GetAllTodosUseCase`를 구현해보겠습니다. 다음과 같이 작성해보세요:

```swift
import Foundation

protocol GetAllTodosUseCase {
    func execute() async throws -> [Todo]
}

struct GetAllTodosUseCaseImpl: GetAllTodosUseCase {
    private let todoRepository: TodoRepository
    
    init(todoRepository: TodoRepository) {
        self.todoRepository = todoRepository
    }
    
    func execute() async throws -> [Todo] {
        return try await todoRepository.getAllTodos()
    }
}
```

이 코드의 주요 특징들:
1. 프로토콜과 구현체 분리
2. 의존성 주입을 통한 `TodoRepository` 사용
3. 비즈니스 로직 캡슐화