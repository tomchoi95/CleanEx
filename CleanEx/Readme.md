CleanEx/
├── Domain/                    # 도메인 레이어 (비즈니스 로직)
│   ├── Entities/             # 도메인 엔티티
│   │   └── Todo.swift        # 할 일 엔티티
│   ├── UseCases/            # 유스케이스
│   │   └── TodoUseCase.swift # 할 일 관련 비즈니스 로직
│   ├── Repositories/        # 레포지토리 인터페이스
│   │   └── TodoRepository.swift
│   └── Common/              # 도메인 공통 요소
│       └── DomainError.swift
│
├── Data/                     # 데이터 레이어
│   ├── Models/              # 데이터 모델
│   │   ├── DTO/            # 데이터 전송 객체
│   │   │   └── TodoDTO.swift
│   │   └── Local/          # 로컬 데이터 모델 (SwiftData)
│   │       └── TodoLocalModel.swift
│   ├── DataSources/        # 데이터 소스
│   │   └── Local/         # 로컬 데이터 소스
│   │       └── TodoLocalDataSource.swift
│   └── Repositories/       # 레포지토리 구현체
│       └── TodoRepositoryImpl.swift
│
└── Presentation/            # 프레젠테이션 레이어 (MVVM)
    ├── Views/              # SwiftUI 뷰
    │   ├── TodoListView.swift
    │   └── TodoDetailView.swift
    ├── ViewModels/        # 뷰모델
    │   ├── TodoListViewModel.swift
    │   └── TodoDetailViewModel.swift
    └── Common/           # 프레젠테이션 공통 요소
        └── ViewError.swift
```
각 레이어의 역할:

1. **도메인 레이어**:
   - 비즈니스 로직의 핵심
   - 외부 의존성이 없음
   - 순수한 Swift 코드만 사용

2. **데이터 레이어**:
   - 데이터 접근 로직
   - SwiftData를 사용한 로컬 저장소
   - 도메인 모델과 데이터 모델 간의 변환

3. **프레젠테이션 레이어**:
   - MVVM 패턴 적용
   - SwiftUI 뷰와 뷰모델
   - 사용자 인터페이스 로직