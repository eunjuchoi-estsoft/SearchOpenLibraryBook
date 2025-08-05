# 프로젝트 개요

> 프로젝트 기간: 7/29 ~ 8/4
> 
> 사용자가 입력한 키워드를 기반으로 도서 목록을 검색하고, 결과 리스트에서 도서를 선택하면 상세 정보를 확인할 수 있는 SwiftUI 기반 도서 탐색 앱입니다.


# 동작 화면
| <img width=220px src="https://github.com/user-attachments/assets/819b26f3-7692-49b7-a241-2c04329efd42"> | <img width=220px src="https://github.com/user-attachments/assets/c6651704-f5ef-46a4-ab43-9e2e404b3e28"> | <img width=220px src="https://github.com/user-attachments/assets/194e457f-2fde-4f2c-be69-6119d29f91d9"> | <img width=220px src="https://github.com/user-attachments/assets/ddcb3213-72cb-46fc-9368-6f2f0ecdbb2f"> |
| --- | --- | --- | --- |
| 검색 기능 | 검색 결과 없음 | 상세 화면 | 네트워크 에러 발생 | 

# 개발 환경
- Xcode 16.4
- Minimum target: 16.0

# 프레임워크 및 API

- SwiftUI
- URLSession - 네트워킹
- Swift Concurrency - 비동기 처리

# 외부 API

[OpenLibrary](https://openlibrary.org/)

# 폴더 구조
<img width="340" height="443" alt="스크린샷 2025-08-05 오전 10 24 08" src="https://github.com/user-attachments/assets/2294ffbc-bf05-43fe-a11d-6420438ea668" />


# 아키텍처 - 단방향 아키텍처

[**TCA**](https://github.com/pointfreeco/swift-composable-architecture/tree/main)(The Composable Architecture)의 구조를 참고하여 단방향 아키텍처를 구성했습니다.

**`View → Action → Store → Reducer → State → View`**  

<img width="1566" height="1074" alt="mvi-architecture" src="https://github.com/user-attachments/assets/4223a0de-0b87-45d5-aeb5-e525eb462390" />

- **State:** 비즈니스 로직을 수행하거나 UI를 그릴 때 필요한 데이터의 집합 (View에서 필요한 상태)
- **Action:** 사용자로부터 발생하는 이벤트나 노티피케이션 등 뷰에서 생길 수 있는 모든 액션과 API 호출 결과를 나타내는 타입
- **Effect:** 네트워크 요청, 디스크에서 저장/로드, 타이머 생성 등과 같은 작업을 수행하며 `reduce()`의 리턴값으로 사용됩니다.
- **Reducer:** Action을 전달받아 이를 처리 후 결과를 State의 상태를 변경해 UI를 업데이트하도록 하는 **로직**을 구현하는 메서드입니다. API 요청과 같은 이벤트를 Effect를 이용해 실행하고 Action을 이용해 결과를 다시 전달합니다.
- **Store:**  Reducer를 관리하는 객체. 사용자 액션을 Store로 전송하여 Reducer와 Effect를 실행할 수 있도록 하고 스토어의 상태 변화를 관찰하여 UI를 업데이트할 수 있습니다.

# 주요 구현 사항

## 네트워크 레이어 구성
<img width="304" height="330" alt="스크린샷 2025-08-05 오전 9 12 17" src="https://github.com/user-attachments/assets/20d9ad3a-3af3-4af9-a853-aab907048ba2" />

URLSession 을 이용한 네트워킹을 위한 추상화 작업 진행

- **Core:** 모든 앱의 통신에 공통적으로 필요한 객체들을 포함하는 폴더
    - `HTTPMethod` : HTTPMethod
        - get, post, patch, put, delete
    - `NetworkError`: 모든 네트워크 통신에서 공통적으로 발생하는 에러
    - `NetworkConstants`: 네트워크 통신에 필요한 기본 구성 요소들을 열거형을 이용해 미리 정의
        - HederType, HTTPHeaderField, ContentType, HTTPTask
    - `NetworkEnvironment` : 환경 변수 정의
    - `EndpointType`: URLRequest에 필요한 앤드포인트들을 프로퍼티로 가지는 protocol
        - creatURLRequest() 를 이용해 최종 URLRequest 만듦
    - `BaseEndpoint`: EndpointType을 준수하는 protocol
        - extension으로 모든 통신에 공통적인 부분 기본 정의
    - `NetworkRouter`: URLSession을 이용해 request를 수행하는 객체
- **Foundation:** 현재 앱의 네트워킹 작업에 공통적으로 필요한 객체들을 포함하는 폴더
    - `SearchError`: StatusCode별 에러 케이스 정의
    - `NetworkProvider`: Router를 이용해 request 작업 진행하고, 성공 시 decode, 실패 시 statusCode를 이용한 에러 분기 처리 작업
- **Search:** 검색 네트워킹 수행에 필요한 객체들을 포함하는 폴더
    - `SearchEndpoint`: 검색 API 요청에 필요한 모든 endpoint를 정의하는 열거형
        - 도서 검색 API 하나이므로 searchBook 케이스 하나만 존재
    - `SeachService`: 검색 네트워킹 작업을 수행하는 객체
        - NetworkProvider를 이용해 request 작업 수행
        - 성공 시 decoded된 데이터를 받아 프레젠테이션 레이어에서 필요한 모델로 매핑해 결과 반환
        - 실패 시 에러 throw
