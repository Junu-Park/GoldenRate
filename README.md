<img width="100" height="100" src="https://github.com/user-attachments/assets/38be4c38-17b5-4d82-8211-34e4d9f99de5">

# 금니 (GoldenRate)
> 예적금 금리 정보를 한눈에, 자신에게 맞는 예적금 상품을 쉽게 찾을 수 있는 iOS 앱

App Store 출시 (2025, 현재 비공개)

---

## 📱 소개
**금니**는 한국은행(ECOS)과 금융감독원(FSS) 공공 API를 활용하여 최신 금리 정보를 차트로 시각화하고, 예적금 상품을 조건별로 비교/검색할 수 있는 앱입니다.

### 주요 기능
- ⭐️ 최근 12개월 금리 추이 차트 (기준금리 / 1금융권 / 2금융권)
- ⭐️ 예적금 상품 금리 TOP3 랭킹
- ⭐️ 금융권 / 이자율 유형 / 상품명 기반 맞춤 필터 검색
- ⭐️ 정기예금/적금 이자 계산기 (세전/세후)
- ⭐️ 홈 화면 위젯을 통한 최신 금리 정보 제공

---

## 📸 스크린샷
<div align="center">
  <img src="https://github.com/user-attachments/assets/69c6f17f-0b95-4232-b7be-187ac631b6cb" width="19%">
  <img src="https://github.com/user-attachments/assets/12b2c6d2-f668-4718-acf1-08109ca6168b" width="19%">
  <img src="https://github.com/user-attachments/assets/e84b75ba-f9b8-486f-b2c5-86d046793287" width="19%">
  <img src="https://github.com/user-attachments/assets/e67c47dd-bf4c-46a9-8a27-a73b193ec90f" width="19%">
  <img src="https://github.com/user-attachments/assets/67bb43a4-9ba2-4033-b372-466e98542756" width="19%">
</div>

---

## 🛠 개발 정보
| 구분 | 내용 |
|------|------|
| ⏰ 개발 기간 | 최초 버전 2주 (2025. 03. 25 - 2025. 04. 06), 이후 v1.1.4까지 업데이트 (~2025. 11) |
| 👨‍💻 개발 인원 | 1명 (개인 프로젝트) |
| 📋 담당 역할 | iOS 개발 / 기획 / 디자인 |
| 📱 최소 지원 버전 | iOS 16.0+ |

---

## 📚 기술 스택
| 구분 | 기술 |
|------|------|
| Language | Swift |
| UI | UIKit (Code-based), SwiftUI (Charts) |
| Architecture | MVVM + Repository Pattern |
| Reactive | Combine |
| Network | URLSession (async/await) |
| Visualization | Swift Charts |
| Widget | WidgetKit |
| Analytics | Firebase Analytics & Crashlytics |

---

## 📁 프로젝트 구조
```
GoldenRate/
├── App/                        # AppDelegate, SceneDelegate
├── Data/
│   ├── Network/
│   │   ├── NetworkManager       # URLSession 기반 네트워크 매니저
│   │   ├── APIRouter            # API 라우터 프로토콜
│   │   ├── APIConfig            # Info.plist 기반 환경 설정
│   │   ├── FSS/                 # 금융감독원 API (예적금 상품)
│   │   └── ECOS/                # 한국은행 API (금리 통계)
│   └── Local/                   # Mock 데이터
├── Model/
│   ├── DTO/                     # API 응답 매핑 객체
│   ├── Entity/                  # 비즈니스 모델
│   └── Enum/                    # 상품 유형, 금리 유형, 정렬 등
├── Repository/                  # Protocol 기반 데이터 추상화 계층
├── ViewModel/                   # Input/Output 패턴 ViewModel
├── Presentation/
│   ├── Home/                    # 금리 차트 + TOP3 랭킹
│   ├── Search/                  # 상품 검색 + 필터 + Skeleton UI
│   ├── Calculator/              # 이율 계산기
│   ├── ProductDetail/           # 상품 상세 정보
│   └── Custom/                  # Base 클래스, 커스텀 컴포넌트
├── Extension/                   # Constraint DSL, UIView 확장 등
└── Resource/                    # 폰트, 컬러, 이미지, 다국어
GoldenRateWidget/                # 홈 화면 위젯
├── View/                        # 위젯 UI
├── Model/                       # 위젯 데이터 모델
└── Network/                     # 위젯 전용 네트워크 (5초 타임아웃)
```

---

## 🏗 아키텍처

### MVVM + Repository Pattern
```
View(ViewController) → ViewModel → Repository(Protocol) → NetworkManager
         ↑                |
         └── Combine ─────┘
```

- **ViewModel**: `Input/Output` 프로토콜 기반 단방향 데이터 흐름
- **Repository**: 프로토콜로 추상화하여 `Real`/`Mock` 구현체 분리
- **Combine**: `CurrentValueSubject` / `PassthroughSubject`를 활용한 반응형 바인딩

### 🔄 Input/Output 패턴
```swift
protocol ViewModel {
    associatedtype Input
    associatedtype Output
    func transform(input: Input) -> Output
}
```
ViewController에서 사용자 이벤트를 `Input`으로 전달하면, ViewModel이 비즈니스 로직을 처리하여 `Output`으로 변환합니다. Combine의 `AnyPublisher`를 통해 View와 ViewModel 간 양방향 의존성을 제거하고 단방향 데이터 흐름을 유지합니다.

### 🗂 Repository Pattern
```swift
protocol HomeRepository {
    func getRate(type: RateType) async throws -> RateResponseDTO
    func getDepositProduct(type: FinancialCompanyType) async throws -> DepositProductResponseDTO
    func getSavingProduct(type: FinancialCompanyType) async throws -> SavingProductResponseDTO
}
```
ViewModel이 네트워크 계층에 직접 의존하지 않도록 Repository 프로토콜로 추상화하여, 테스트 시 `MockRepository`로 교체할 수 있는 구조를 갖추었습니다.

---

## 💭 기술적 도전과 해결

### 1. Apple 프레임워크 중심 설계
유지보수성과 장기적 호환성을 고려하여 Third-party 의존성을 최소화했습니다.

| 영역 | 흔히 쓰는 서드파티 | 이 프로젝트의 선택 |
|------|------|------|
| 반응형 바인딩 | RxSwift | Combine (처음부터 채택) |
| 네트워크 | Alamofire | URLSession + async/await (처음부터 채택) |
| Auto Layout | SnapKit | 1.0 ~ 1.1.2에서 사용 → 1.1.3에서 제거, Custom DSL로 대체 |

### 2. @resultBuilder 기반 Auto Layout DSL
SnapKit 제거 후 NSLayoutConstraint만으로 레이아웃을 구성하면서도 가독성을 유지하기 위해, `@resultBuilder`를 활용한 선언적 Constraint DSL을 직접 구현했습니다.

```swift
// 적용 예시
self.symbolImageSkeleton.setConstraints {
    $0.leadingAnchor.constraint(equalTo: $0.superview, constant: 16)
    $0.centerYAnchor.constraint(equalTo: $0.superview)
    $0.widthAnchor.constraint(equalToConstant: 50)
    $0.heightAnchor.constraint(equalToConstant: 50)
}
```
`translatesAutoresizingMaskIntoConstraints` 설정과 `NSLayoutConstraint.activate`를 내부에서 처리하여 반복 코드를 제거하고, 빌더 패턴을 통해 조건부 제약 조건도 지원합니다.

### 3. Shimmer Skeleton UI
네트워크 로딩 중 사용자 공백 경험을 최소화하기 위해 Core Animation 기반의 Shimmer 효과를 직접 구현했습니다.

- `CAGradientLayer`로 그라디언트 마스크 생성
- `CABasicAnimation`의 `locations` 키패스를 활용하여 좌→우 이동 애니메이션 구현
- `didMoveToWindow()` / `layoutSubviews()`에서 애니메이션 라이프사이클을 관리하여 셀 재사용 시에도 안정적으로 동작

<div align="center">
  <img src="https://github.com/user-attachments/assets/2ae0d091-948d-4560-98d0-9d3b463b0768" width="300">
</div>

### 4. 다중 페이지 API 데이터 통합
금융감독원 API는 페이지네이션 기반으로 응답하여, 첫 번째 페이지에서 `max_page_no`를 확인한 후 나머지 페이지를 순차적으로 호출하고 결과를 단일 DTO로 병합하는 방식으로 처리했습니다.

### 5. Swift Concurrency 기반 병렬 네트워크 요청
`async let`을 활용하여 독립적인 API 호출을 병렬로 실행하고, 모든 응답이 완료된 시점에 결과를 통합합니다.
```swift
async let baseRate = repository.getRate(type: .base)
async let firstRate = repository.getRate(type: .first)
async let secondRate = repository.getRate(type: .second)
return try await (baseRate, firstRate, secondRate)
```

### 6. 위젯 네트워크 최적화
메인 앱(15초)과 위젯(5초)의 타임아웃을 분리 설정하여, 홈 화면 위젯 렌더링 지연을 방지하고 빠른 실패(Fail-Fast)를 통해 에러 상태로의 전환을 신속하게 처리합니다.

### 7. Dark Mode 대응
`traitCollectionDidChange`를 활용하여 다크 모드 전환 시 `CALayer`의 `shadowColor` 등 `CGColor` 기반 속성이 동적으로 반영되도록 처리했습니다.

### 8. 앱·위젯 금리 지표 기준 통일 (v1.1.2)
출시 후 직접 앱을 사용하며 점검하던 중, 홈 차트와 위젯이 **같은 이름의 금리를 서로 다른 한국은행(ECOS) 통계 항목**에서 가져오고 있는 것을 발견했습니다.

| 표시 지표 | 앱 (홈 차트) | 위젯 |
|------|------|------|
| 1금융권 예금금리 | 정기예금(1년) | 순수저축성예금 |
| 2금융권 예금금리 | 상호저축은행 정기예금(1년) | 상호금융 저축성예금 |

각 통계 항목의 정의를 비교해 "무엇을 보여줄 것인가"를 기준으로 하나로 통일했습니다.
- **1금융권 → 순수저축성예금**: 정기예금(1년)은 1년 만기 상품 하나의 금리만 반영합니다. 정기예금(모든 만기)·정기적금·상호부금 등 저축성 예금 전체를 신규 취급액으로 가중평균한 순수저축성예금이 1금융권 금리 수준을 더 잘 대표한다고 판단했습니다.
- **2금융권 → 상호저축은행 정기예금(1년)**: 상호금융 저축성예금은 농협·수협 등 단위조합의 지표입니다. 앱이 보여주려는 2금융권은 저축은행이므로 저축은행 지표로 맞췄습니다. ECOS에서 제공하는 저축은행 정기예금 지표는 이 항목 하나뿐이었습니다.

---
