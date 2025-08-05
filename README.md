# 프로젝트 개요

> 프로젝트 기간: 7/29 ~ 8/4
> 
> 사용자가 입력한 키워드를 기반으로 도서 목록을 검색하고, 결과 리스트에서 도서를 선택하면 상세 정보를 확인할 수 있는 SwiftUI 기반 도서 탐색 앱입니다.


# 동작 화면
| <img width=220px src="https://github.com/user-attachments/assets/98f53819-679a-4979-bf57-5fc7218a70b4"> | <img width=220px src="https://github.com/user-attachments/assets/51f1cc0d-2421-4d27-b0d4-03402876036c"> | <img width=220px src="https://github.com/user-attachments/assets/ec446fc2-a6e9-40ab-878f-400965924090"> | <img width=220px src="https://github.com/user-attachments/assets/24d51ef8-1a42-40df-b3f6-9efc622569d5"> |
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

<img width="1000" height="900" alt="mvi-architecture" src="https://github.com/user-attachments/assets/4223a0de-0b87-45d5-aeb5-e525eb462390" />

- **State:** 비즈니스 로직을 수행하거나 UI를 그릴 때 필요한 데이터의 집합 (View에서 필요한 상태)
- **Action:** 사용자로부터 발생하는 이벤트나 노티피케이션 등 뷰에서 생길 수 있는 모든 액션과 API 호출 결과를 나타내는 타입
- **Effect:** 네트워크 요청, 디스크에서 저장/로드, 타이머 생성 등과 같은 작업을 수행하며 `reduce()`의 리턴값으로 사용됩니다.
- **Reducer:** Action을 전달받아 이를 처리 후 결과를 State의 상태를 변경해 UI를 업데이트하도록 하는 **로직**을 구현하는 메서드입니다. API 요청과 같은 이벤트를 Effect를 이용해 실행하고 Action을 이용해 결과를 다시 전달합니다.
- **Store:**  Reducer를 관리하는 객체. 사용자 액션을 Store로 전송하여 Reducer와 Effect를 실행할 수 있도록 하고 스토어의 상태 변화를 관찰하여 UI를 업데이트할 수 있습니다.

# 주요 구현 사항

## 네트워크 레이어 구성
<img width="304" height="330" alt="스크린샷 2025-08-05 오전 9 12 17" src="https://github.com/user-attachments/assets/20d9ad3a-3af3-4af9-a853-aab907048ba2" />

URLSession 을 이용한 네트워킹을 위한 추상화 작업 진행
- **Core:** 모든 앱의 통신에 공통적으로 필요한 객체들을 포함하는 폴더
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
- **Foundation:** 현재 앱의 네트워킹 작업에 공통적으로 필요한 객체들을 포함하는 폴더
    - `SearchError`: StatusCode별 에러 케이스 정의
    - `NetworkProvider`: Router를 이용해 request 작업 진행하고, 성공 시 decode, 실패 시 statusCode를 이용한 에러 분기 처리 작업
- **Search:** 검색 네트워킹 수행에 필요한 객체들을 포함하는 폴더
    - `SearchEndpoint`: 검색 API 요청에 필요한 모든 endpoint를 정의하는 열거형
        - 도서 검색 API 하나이므로 searchBook 케이스 하나만 존재
    - `SeachService`: 검색 네트워킹 작업을 수행하는 객체
        - NetworkProvider를 이용해 request 작업 수행
        - 성공 시 decoded된 데이터를 받아 프레젠테이션 레이어에서 필요한 모델로 매핑해 결과 반환
        - 실패 시 에러 throw

## 단방향 아키텍처 구성 - Reducer, Store

### 단방향 아키텍처 선택 이유?

State의 변경을 예측 가능하도록 하여 에러 추적과 확장이 쉬운 코드 구조를 만들어 유지보수성을 높이기 위해.

View는 상태를 직접 수정할 수 없습니다. 대신, 사용자 액션(ex. 버튼 터치)이 발생하면 `send(_ action:)` 메서드를 통해 Action을 Store에 보냅니다. 

Store는 이 Action을 Reducer에 전달하고, Reducer의 reduce() 를 통해서만 상태를 변경할 수 있습니다. 

이처럼 상태 변경이 한 방향(`View → Action → Store → Reducer → State → View` )으로만 일어나므로 데이터 흐름을 추적하기 쉬워집니다.

### ReducerProtocol

```swift
protocol ReducerProtocol {
    associatedtype State
    associatedtype Action
    
    typealias Effect = EffectType<Action>
    
    var initialState: State { get }
    
    func reduce(state: inout State, action: Action) -> Effect
}

/// 다른 액션을 트리거하는 Side Effect
enum EffectType<Action> {
    case task(operation: @Sendable () async -> Action)
    case none
}
```

### Store

Reducer를 관리하는 객체

상태(State)를 관리하고, 상태를 변경하는 로직(Reducer)을 실행하며, Side Effect를 처리하는 역할을 수행

```swift
/// Reducer 를 관리하는 Store
@MainActor
final class Store<Reducer: ReducerProtocol>: ObservableObject {
    
    // MARK: - Properties
    
    @Published private(set) var state: Reducer.State
    private let reducer: Reducer
    private var tasks: Set<Task<(), Never>> = []

    // MARK: - Initializer
    
    init(reducer: Reducer) {
        self.reducer = reducer
        self.state = reducer.initialState
    }
    
    // MARK: - Deinitializer
    
    deinit {
        tasks.forEach { $0.cancel() }
    }

    // MARK: - Public Methods
    
    /// 액션이 발생하면 호출되는 메서드
    /// action을 받아 내부의 send 메서드를 호출하여 상태 변경 프로세스를 시작
    func send(_ action: Reducer.Action) {
        send(&state, action)
    }

    // MARK: - Private Methods

    private func send(_ state: inout Reducer.State, _ action: Reducer.Action) {
        // reducer를 실행하여 상태를 변경하고, effect를 반환받습니다.
        let effect = reducer.reduce(state: &state, action: action)
        
        // 반환된 이펙트의 종류에 따라 추가 작업을 처리합니다.
        switch effect {
        // 이펙트가 비동기 작업(.task)인 경우
        case let .task(operation):
            // 비동기 Task를 생성
            let newTask = Task {
                // operation 클로저를 비동기적으로 실행하고,
                // 완료되면 그 결과를 send()로 전달합니다.
                let nextAction = await operation()
                send(nextAction)
            }
            tasks.insert(newTask)
        // 이펙트가 없는 경우(.none)
        case .none:
            break
        }
    }
}
```

## 화면 전환 담당 객체 - Coordinator

- `Coordinator`: 화면전환에 필요한 프로퍼티와 메서드를 정의하는 프로토콜
    
    ```swift
    protocol Coordinator {
        var path: NavigationPath { get set }
        var sheet: AppScene? { get set }
        var initialScene: AppScene { get set }
        
        func push(_ scene: AppScene)
        func pop()
        func popToRoot()
        func present(sheet: AppScene)
        func dismiss()
    }
    ```
    
- `MainCoordinator`: Coordinator 프로토콜을 준수하여 화면 전환에 필요한 메서드들을 구현하여 실제 화면 전환을 담당하는 객체
    
    ```swift
    final class MainCoordinator: ObservableObject, Coordinator {
        
        // MARK: - Properties
        
        @Published var path: NavigationPath
        @Published var sheet: AppScene?
        var initialScene: AppScene
        
        // MARK: - Initializer
        
        init(_ initialScene: AppScene) {
            self.path = NavigationPath()
            self.initialScene = initialScene
        }
        
        // MARK: - Public Methods
        
        func push(_ scene: AppScene) {
            path.append(scene)
        }
        
        func pop() {
            path.removeLast()
        }
        
        func popToRoot() {
            path.removeLast(path.count)
        }
        
        func present(sheet: AppScene) {
            self.sheet = sheet
        }
        
        func dismiss() {
            self.sheet = nil
        }
    }
    ```
    
- App
    
    ```swift
    @main
    struct SearchOpenLibraryBookApp: App {
        @StateObject private var coordinator = MainCoordinator(.searchMain)
    
        var body: some Scene {
            WindowGroup {
                NavigationStack(path: $coordinator.path) {
                    ViewFactory.build(scene: coordinator.initialScene, coordinator: coordinator)
                        .navigationDestination(for: AppScene.self) { scene in
                            ViewFactory.build(scene: scene, coordinator: coordinator)
                        }
                        .sheet(item: $coordinator.sheet) { scene in
                            ViewFactory.build(scene: scene, coordinator: coordinator)
                        }
                }
            }
        }
    }
    ```
    
    화면 전환을 담당하는 객체인 Coordinator를 사용해 NavigationStack과 전환 로직을 View에서 분리하여 **View 간 결합도를 낮추었습니다.**   
    

## 이미지 캐싱 - CachedAsyncImage

기존의 `AsyncImage` 는 별도의 캐싱 기능을 구현하지 않습니다.

해당 앱은 이미지가 많은 뷰로 구성되어있기 때문에 매번 새로 url을 이용해 이미지를 다운로드 하는 작업은 메모리 자원 낭비 및 사용성 저하 문제가 있다고 생각했습니다.

- 메모리 부하 방지
- 이전 로드된 이미지는 다시 로드하지 않도록 해서 사용성 향상

위의 두가지의 이점 때문에 이미지 캐싱을 적용했습니다.

**URLCache를 이용한 CachedAsyncImage 구현**

- 인메모리, 온디스크 방식을 모두 지원하는 URLCache를 이용해 이미지 캐싱 구현

```swift
struct CachedAsyncImage<Content: View, Placeholder: View>: View {
    
    // MARK: - Properties
    
    @State private var image: Image? = nil
    @State private var isLoading = false
    
    private let url: URL?
    private let content: (Image) -> Content
    private let placeholder: () -> Placeholder
    
    // MARK: - Initializer
    
    init(
        url: URL?,
        @ViewBuilder content: @escaping (Image) -> Content,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ) {
        self.url = url
        self.content = content
        self.placeholder = placeholder
    }
    
    // MARK: - Body
    
    var body: some View {
        if let image = image {
            content(image)
        } else {
            placeholder()
                .onAppear {
                    Task {
                        await loadImage()
                    }
                }
        }
    }
}

// MARK: - Private Methods

extension CachedAsyncImage {
    
    private func loadImage() async {
        guard let url = url, !isLoading else { return }
        
        isLoading = true
        
        // 캐시 확인
        let request = URLRequest(url: url)
        if let cachedResponse = URLCache.shared.cachedResponse(for: request),
           let cachedImage = UIImage(data: cachedResponse.data) {
            await MainActor.run {
                self.image = Image(uiImage: cachedImage)
                self.isLoading = false
            }
            return
        }
        
        // 캐시에 저장된 이미지 없다면 네트워크에서 이미지 다운로드
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // Cache the image
            let cachedData = CachedURLResponse(response: response, data: data)
            URLCache.shared.storeCachedResponse(cachedData, for: request)
            
            if let uiImage = UIImage(data: data) {
                await MainActor.run {
                    self.image = Image(uiImage: uiImage)
                    self.isLoading = false
                }
            }
        } catch {
            await MainActor.run {
                self.isLoading = false
            }
        }
    }
}
```

### 이미지 캐싱 전/후 비교
| <img width="1004" height="548" alt="스크린샷 2025-08-04 오후 1 38 39" src="https://github.com/user-attachments/assets/eb293ae2-103b-4284-9046-3ad760461d02" /> | <img width="1009" height="541" alt="스크린샷 2025-08-04 오후 1 49 51" src="https://github.com/user-attachments/assets/d00caca7-e55c-4935-9cd8-db967774d56c" /> |
| --- | --- |
| 이미지 캐싱 전 | 이미지 캐싱 후 |


전체 메모리 사용량이 크게 줄지는 않았지만 (검색 기능 특성상 새로운 데이터를 받을 일이 많기 때문) 동일 검색 결과 혹은 위로 스크롤 시 메모리 사용량이 증가 하지 않고 **유지**되는 것을 확인할 수 있었습니다.
