## MVP

- M : Model
- V : View
- P : Presenter

<img src="https://github.com/yurrrri/iOS_Architecture_Pattern/assets/37764504/8a10dc99-ebb1-4fc5-a87c-01b2cfeb138c" width="500"/>

- View: 사용자의 액션을 Presenter에게 전달, UI를 그림
- Presenter: 이에 따라 Model의 데이터 갱신, 비즈니스 로직을 수행, View 갱신
- Model: Model이 비즈니스 로직에 따라 데이터를 변경하면, 변화 내용을 Presenter에게 전달

**MVP가 부합하는 좋은 아키텍처의 조건** <br/>

장점 : 1. 역할 분리 2. 테스트 용이 <br/>
단점 : 3. 사용성의 경우 간단한 프로젝트에서 사용하기에는 복잡할 수 있음

**🚨 문제점**  <br/>

Controller의 역할을 Presenter로 분리하는 대신, 여전히 Presenter가 비대하다는 단점이 존재
