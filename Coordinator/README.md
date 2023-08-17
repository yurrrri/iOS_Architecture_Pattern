## Coordinator

<img src="https://github.com/yurrrri/iOS_Architecture_Pattern/assets/37764504/0d750080-a879-44e7-8294-c4acec50a9f3" width="700"/> <br/>

>  A coordinator is an object that bosses one or more view controllers around. Taking all of the driving logic out of your view controllers, and moving that stuff one layer up is gonna make your life a lot more awesome.
- 코디네이터는 ViewController의 화면 계층 관리 및 화면 전환 로직을 가져감으로써 ViewController가 View의 역할에 집중하고, 화면 전환 로직의 재사용성을 높인 디자인 패턴
- 화면 전환하는 코드를 모듈화하여 화면 계층을 파악/관리하기 용이
- 디자인 패턴이기때문에 아키텍처와 무관하나, 화면 전환 부분을 가져감으로써 아키텍처와 연관됨. 주로 MVVM과 많이 엮여서 MVVM-C 라는 패턴이 많이 쓰임

## 토이 프로젝트
### MVVM-C (MVVM + Coordinator)

### Model

### View

### ViewModel

### Coordinator

### Reference

https://lena-chamna.netlify.app/post/ios_design_pattern_coordinator_basic/
