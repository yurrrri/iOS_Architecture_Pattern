## iOS Architecture Pattern

iOS 아키텍처 패턴에 대해 공부하고 정리하는 레포입니다.

#### 공부를 시작한 계기?
프로젝트 출시 일정에 맞춘다고 일단 급하게 개발하고 출시를 한 다음에, "나중에 리팩토링 해야지~" 했다가 <br/>
이후 기능 추가나 버그 수정을 할 때 나 조차도 이해 못하는 코드를 보고 멘붕이 왔고 <br/>
다시 엎어버려야 하나 고민이 될정도로 코드가 너무 엉망이었던 경험이 있었기에, 다음 프로젝트는 설계부터 잘 해두는것이 매우 중요하다는 생각이 들어 공부 시작 <br/>

### 아키텍처가 중요한 이유?

여러 아키텍쳐 패턴을 본격적으로 들어가기 전, 막연히 "프로젝트는 나 혼자만 만드는게 아니기에, 처음부터 설계를 잘하면 이후에 고생을 덜 하기에" 라고만 생각했기 때문에 더 구체적으로 아키텍처가 왜 중요한지 알아보았습니다.

**1. 개발자의 생산성과 직결**

<img src=https://github.com/paicooha/Growlibb-iOS/assets/37764504/576a38bb-ac6c-4997-9fd1-af112b438466 width="500"/>

출시 횟수에 따른 개발자의 생산성이 지속적으로 낮아지는 현상은 다음으로 설명할 수 있다.
- 시스템을 급하게 만들거나
- 결과물의 총량을 개발자의 수에 의지하거나
- 코드의 설계와 구조에 대해 고민하지 않기에

4회차부터는 오히려 기능 개발보다는 코드를 파악하고 이해하는데 시간을 쓰며 엉망인 코드를 개선하는 데에 시간 투자를 대부분 쏟는, 생산성이 매우 떨어지는 일이 발생하게 된다.
<br/>

**2. 적은 비용으로 유지보수를 용이하게 하기 위해**

<img src=https://github.com/paicooha/Growlibb-iOS/assets/37764504/e25650d9-b1a6-488b-9dc8-8881af4b2a63 width="500"/>

- 사진에서 보는 것처럼, 프로덕트 단계가 진행되면 진행될수록 변경에 드는 비용이 점점 커지게 된다. 
- 즉, 시장 출시가 너무 급한 나머지 코드를 엉망으로 짜다가 후에 수정하려고 할 때 오히려 더 많은 비용이 발생한다는 것이다.  <br/> (내가 이번에 제대로 느꼈던 포인트..🥺 나중에 리팩토링 하자고 생각했던 게 걷잡을 수 없이 커져서 오히려 더 많은 비용을 야기했다.)

### 좋은 아키텍처가 있는가? 있다면 조건은 무엇인가?
<u>아키텍처에 정답은 없다.</u> 내가 진행하고 있는 프로젝트의 성격에 맞게 적절한 아키텍처를 선택해야한다. <br/><u>하지만 좋은 아키텍처의 기준은 존재한다.
</u>

#### 1. 확실한 역할의 분배
- 객체들의 역할이 확실한가? 즉 각 모듈이 독립적으로 동작하는가?
- 객체지향의 5원칙인 SOLID의 [S(olid Responsibility)](https://inpa.tistory.com/entry/OOP-%F0%9F%92%A0-%EA%B0%9D%EC%B2%B4-%EC%A7%80%ED%96%A5-%EC%84%A4%EA%B3%84%EC%9D%98-5%EA%B0%80%EC%A7%80-%EC%9B%90%EC%B9%99-SOLID) 에 기반
- 모듈의 독립성이 떨어지면 각 모듈의 역할이 모호하여 테스팅에 어려움이 있다. 반면에, 역할이 독립적이고 확실하게 분배된다면 재사용성이 증가하며 역할 별 테스트가 가능해진다.

#### 2. 테스트가 용이한가?
- 테스트는 사용자에게 발견되기 전에 개발단계에서 사전에 이슈를 찾아낼 수 있다.
- 테스트는 리팩토링 후에도 기능이 정상적으로 작동하는지 검증할 수 있기 때문에, 안심하고 코드를 수정할 수 있다.
- 빠른 시간 내에 코드의 동작 방식과 결과를 확인할 수 있어, 코드 자체가 곧 명세서가 된다.

#### 3. 사용하기 편리한가?
- 개발을 빠르게 진행해야할 때 고려해야하는 사항

---
### MVC
- https://github.com/yurrrri/iOS_Architecture_Pattern/tree/main/MVC

### MVP
- https://github.com/yurrrri/iOS_Architecture_Pattern/tree/main/MVP

### MVVM
- https://github.com/yurrrri/iOS_Architecture_Pattern/tree/main/MVVM

### VIPER

### RIBs

### Clean Architecture


(reference: [클린 아키텍처](http://www.yes24.com/Product/Goods/77283734), [클린 코드](http://www.yes24.com/Product/Goods/11681152), [iOS Architecture Pattern](https://medium.com/ios-os-x-development/ios-architecture-patterns-ecba4c38de52),
[앨런 Swift문법 마스터스쿨](https://www.inflearn.com/course/%EC%8A%A4%EC%9C%84%ED%94%84%ED%8A%B8-%EB%AC%B8%EB%B2%95-%EB%A7%88%EC%8A%A4%ED%84%B0-%EC%8A%A4%EC%BF%A8)
등 기타 레퍼런스)
