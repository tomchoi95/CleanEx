`Domain/Repositories` 폴더 안에 `TodoRepository.swift` 파일을 생성해주세요. 이 파일은 할 일 데이터에 대한 접근을 정의하는 인터페이스가 될 것입니다.

`TodoRepository`는 다음과 같은 메서드들을 포함해야 합니다:
1. `getAllTodos()`: 모든 할 일 목록을 가져오는 메서드
2. `getTodo(id: UUID)`: 특정 할 일을 가져오는 메서드
3. `createTodo(_ todo: Todo)`: 새로운 할 일을 생성하는 메서드
4. `updateTodo(_ todo: Todo)`: 기존 할 일을 수정하는 메서드
5. `deleteTodo(id: UUID)`: 할 일을 삭제하는 메서드

주의사항:
- 모든 메서드는 비동기 처리를 위해 `async` 키워드를 사용
- 에러 처리를 위해 `throws` 키워드 사용
- 메서드 이름은 명확하고 일관성 있게 작성
