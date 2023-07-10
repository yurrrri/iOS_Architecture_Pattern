## MVVM

<img src="https://github.com/yurrrri/iOS_Architecture_Pattern/assets/37764504/d91f6996-ea27-46e9-905d-fd2e1be6bd8f" width="700"/>

- Model: 데이터 모델 (기준 MVC 패턴에서 비즈니스 로직이 ViewModel로 분리된 형태)
- View: View와 Controller를 합쳐서 하나의 View로 보고, View는 사용자의 input을 viewModel에 전달하고 표시하는 역할
- ViewModel: 뷰를 위한 데이터 모델 역할을 하며, Model을 소유하며 전반적인 비즈니스 로직을 담당한다. 이를 통해 View의 변화가 발생할 시 View에 전달

⭐️ **바인딩** <br/>

- 뷰 모델을 통해 일어난 변화를 뷰가 반영하는 것
- 알리는 방법으로는 KVO, 이스케이핑 클로저, Notification 등이 있고
- 서드파티 라이브러리를 활용해 편리하게 바인딩을 구현하는 방법으로 RxSwift, Combine이 있음

❗️ **MVVM과 RxSwift가 서로 잘 어울리는 이유** <br/>
- RxSwift의 핵심은 특정 클래스의 변화를 관찰하고 있다가 이 변화를 뷰에 바인딩함에 있으므로, 뷰 모델에서 일어난 변화를 바로 뷰에 반영하기에 로직이 어울림


✨ **MVVM이 만족하는 좋은 아키텍처의 조건** <br/>

1. 역할 분리 2. 테스트 용이
3. 사용성의 경우 간단한 프로젝트에서 사용하기에는 복잡할 수 있음



🚨 **문제점** 

아키텍처에 정답은 없듯이, MVVM도 마찬가지로 단점이 존재한다. <br/>
바로 MVC 패턴에서 문제였던 특정 클래스의 역할이 과중되어 비대해진다는 부분이 단점으로 지적되는데, 이를 보완한 아키텍처들은 아래와 같은 것들이 있다.

- VIPER
- Clean Architecture

그리고 MVVM을 통해 Controller의 역할을 분리했음에도 여전히 남아있었던 화면 전환의 막중한 책임을 따로 분리한 패턴인 Coordinator를 도입한 아키텍처도 존재한다.
- MVVM-C

