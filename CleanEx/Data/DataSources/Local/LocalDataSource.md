1. **프로토콜 정의**:
   - CRUD 작업을 위한 메서드 정의
   - 비동기 처리 (`async`)
   - 에러 처리 (`throws`)

2. **SwiftData 모델 정의**:
   - `@Model` 매크로 사용
   - `TodoDTO`와 매핑되는 속성들 정의

3. **구현체 작성**:
   - `ModelContext` 주입
   - CRUD 작업 구현
   - `TodoDTO`와 SwiftData 모델 간의 변환 로직
