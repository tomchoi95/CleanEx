Data 레이어의 구조:

1. **Data 레이어의 역할**:
   - 도메인 레이어에서 정의한 인터페이스의 실제 구현을 제공
   - 데이터 소스(로컬/원격)와 도메인 모델 간의 변환을 담당
   - 데이터 접근 로직을 캡슐화

2. **주요 구성 요소**:
   - **Repositories**: 도메인 레이어의 Repository 인터페이스 구현
   - **DataSources**: 실제 데이터 저장소(로컬/원격)와의 통신
   - **Models**: 데이터 전송을 위한 DTO(Data Transfer Object)
