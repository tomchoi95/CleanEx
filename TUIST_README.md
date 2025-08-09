# CleanEx - Tuist Migration Guide

## 프로젝트 구조

Tuist를 사용한 모듈화된 Clean Architecture 프로젝트입니다.

### 레이어별 모듈 구조

```
CleanEx/
├── Project.swift         # 메인 앱 프로젝트 설정
├── Workspace.swift       # 워크스페이스 설정
├── Tuist/
│   ├── Config.swift      # Tuist 전역 설정
│   └── Dependencies.swift # 외부 의존성 관리
└── Modules/
    ├── Domain/           # 도메인 레이어 (비즈니스 로직)
    │   └── Project.swift
    ├── Data/             # 데이터 레이어 (Repository 구현)
    │   └── Project.swift
    ├── Presentation/     # 프레젠테이션 레이어 (UI)
    │   └── Project.swift
    └── DI/               # 의존성 주입 레이어
        └── Project.swift
```

### 의존성 관계

```
App
├── Presentation
│   └── Domain
├── DI
│   ├── Domain
│   ├── Data
│   │   └── Domain
│   └── Presentation
│       └── Domain
```

- **Domain**: 외부 의존성 없음 (순수 비즈니스 로직)
- **Data**: Domain에만 의존
- **Presentation**: Domain에만 의존
- **DI**: 모든 레이어에 의존 (의존성 주입 설정)
- **App**: Presentation과 DI에 의존

## Tuist 명령어

### 프로젝트 생성
```bash
tuist generate
```

### 프로젝트 편집 (Tuist 파일 수정시)
```bash
tuist edit
```

### 의존성 설치 (외부 패키지 추가시)
```bash
tuist fetch
tuist generate
```

### 프로젝트 정리
```bash
tuist clean
```

## 모듈별 역할

### Domain 모듈
- Entities: 비즈니스 모델
- UseCases: 비즈니스 로직
- Repositories: Repository 인터페이스 (프로토콜)

### Data 모듈
- Models: 데이터 모델 (Local, Remote)
- DataSources: 실제 데이터 소스 구현
- Repositories: Repository 구현체

### Presentation 모듈
- Views: SwiftUI 뷰
- ViewModels: 뷰 모델
- Common: 공통 UI 컴포넌트

### DI 모듈
- DIContainer: 의존성 주입 컨테이너
- 모든 레이어의 의존성을 연결

## 새로운 기능 추가 방법

1. **Domain 레이어에 Entity/UseCase 추가**
2. **Data 레이어에 Repository 구현 추가**
3. **Presentation 레이어에 View/ViewModel 추가**
4. **DI 모듈에서 의존성 등록**

## 외부 라이브러리 추가

`Tuist/Dependencies.swift` 파일을 수정하여 추가:

```swift
let dependencies = Dependencies(
    swiftPackageManager: .init(
        [
            .remote(url: "https://github.com/Alamofire/Alamofire", requirement: .upToNextMajor(from: "5.8.0"))
        ],
        productTypes: [:]
    ),
    platforms: [.iOS]
)
```

그 후 다음 명령어 실행:
```bash
tuist fetch
tuist generate
```