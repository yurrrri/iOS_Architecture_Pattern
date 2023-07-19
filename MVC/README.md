## MVC

- M : Model
- V : View
- C : Controller

특이한 점은, iOS에서는 기존 MVC와 Apple이 제시한 Cocoa MVC로 나뉜다.

<img src="https://github.com/paicooha/Growlibb-iOS/assets/37764504/cd91f7fb-7c1d-45ff-8879-b9cd820ded35" width="500"/>

- View: 사용자의 액션을 Controller에게 전달
- Controller: 이에 따른 데이터의 갱신을 Model에게 요청
- Model: Model이 비즈니스 로직에 따라 데이터를 변경하면, 변화 내용을 View에게 전달 -> 갱신된 데이터에 맞추어 View 갱신

🚨 **문제점**  : 3개가 서로 밀접하게 결합되어 있어 재사용성이 줄어들며, 좋은 아키텍처 기준의 1번과 2번 위반

### Apple MVC(Cocoa MVC)

<img src="https://github.com/paicooha/Growlibb-iOS/assets/37764504/4ad4cbc9-df1f-405c-8230-5dacb82f0511" width="500"/>

애플이 제시한 Cocoa MVC에서 Controller는 View와 Model의 중재자로 **View와 Model의 직접적인 연결을 막아서 기존 MVC 보다 독립성을 강화**한 아키텍처이다.

그러나 이 아키텍처에서 "Massive View Controller(비대한 뷰컨트롤러)" 문제가 발생하게 된다.

🚨 **문제점** 
<img src="https://github.com/paicooha/Growlibb-iOS/assets/37764504/88e3e850-eee7-4eea-93eb-265e54e42914" width="500"/>

뷰컨트롤러가 뷰로부터 전달받은 액션을 모델에게 전달하고, 모델이 데이터를 변화시키면 이를 뷰컨트롤러에게 전달하고, 뷰컨트롤러는 다시 뷰에게 전달하고,
ViewController의 역할인 화면 전환, View Controller에 있는 화면 관리까지 함으로 인해
- 뷰컨트롤러의 역할이 매우 비대해지게 되었으며
- 뷰와 컨트롤러가 매우 밀접한 연관관계를 가지면서 오히려 View와 Controller의 독립성이 약화되었다. (특히 코드를 UI를 작성하게 되면 결합도가 더 강해짐)
- 또한 View와 Model을 이론적으로 분리했음에도, ViewController가 Model을 소유하고 있는 형태를 띄는 경우가 많아 View와 Model의 독립성을 보장해주지 않음
- 이로 인해 좋은 아키텍처의 조건 1. 확실한 역할의 분배, 2. 테스트가 용이한가 의 조건에 부합하지 않게 된다.

해당 아키텍처는 iOS 개발자가 가장 먼저 마주하는 아키텍처이기에, 적용하기가 쉬워서 좋은 아키텍처 조건 3. 사용하기 편리한가? 에 부합한 아키텍처이지만 이후에 모호한 객체의 역할 분리로 인해 테스트와 유지보수가 어려워진다.

즉, **빠르고 쉽게 개발을 진행해야할 때 가장 적합한 아키텍처이다.**  

## 토이 프로젝트

### Model

- 모델과 비즈니스 로직을 담당하는 역할

<img width="286" alt="스크린샷 2023-06-07 오전 1 20 23" src="https://github.com/yurrrri/iOS_Architecture_Pattern/assets/37764504/99eed358-7a20-437c-b0a3-34cc00a1f27e"> <br/>

1) TodoData+CoreDataClass
2) TodoData+CoreDataProperties

- Core Data가 생성한  managed object subclass 및 프로퍼티 또는 기능을 편집하기 위해 생성

3) CoreDataManager

- Todo에 관한 비즈니스 로직을 실제로 실행하는 친구
- ToDoData에 대한 CRUD 실행

### View

- UI와 화면에 데이터를 표시하는 로직
- 사용자의 액션을 받게되면 이 액션을 Controller에게 전달

<img width="344" alt="image" src="https://github.com/yurrrri/iOS_Architecture_Pattern/assets/37764504/5f19c8fc-7fab-46d6-80a5-68633ea3495c"> <br/>
(여기에는 없지만 스토리보드에 있는 각각의 뷰도 여기에 속함)

1) TodoCell

- ToDo 테이블뷰의 Cell

<img width="400" alt="image" src="https://github.com/yurrrri/iOS_Architecture_Pattern/assets/37764504/04a69d00-8a40-4c8d-8f34-8fe87032eb08">

- configureUI : cell의 UI 초기화
- configureUIWithData : data를 가지고 View의 내용 변경

2) Storyboard 혹은 각종 xib 파일이 해당 디렉토리에 포함

### Controller

- Model의 데이터 갱신이나 비즈니스 로직 관련한 내용을 Model에게 요청
- View의 변화가 발생할 시, View에게 업데이트 된 내용 전달
- 즉 Model과 View의 중재자 역할을 함

<img width="268" alt="image" src="https://github.com/yurrrri/iOS_Architecture_Pattern/assets/37764504/277650fd-fc62-4241-bbc5-3c10a146308d"> <br/>

```swift
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoManager.getToDoListFromCoreData().count   // 데이터를 가져오는것을 Model에게 요청
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath) as! ToDoCell
      
        let toDoData = toDoManager.getToDoListFromCoreData()   // 데이터를 가져오는것을 Model에게 요청
        cell.toDoData = toDoData[indexPath.row]

        return cell
    }
```
```swift
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        if let toDoData = self.toDoData {
            // 텍스트뷰에 저장되어 있는 메세지
            toDoData.todoText = mainTextView.text
            toDoData.type = temporaryNum ?? 1
            toDoManager.updateToDo(newToDoData: toDoData) {   // Model에게 데이터 update 요청
                print("업데이트 완료")
```
- 직접 CoreData의 데이터를 가져오는게 아니라, Model에게 요청해서 데이터를 가져옴

```swift
        cell.updateButtonPressed = { [weak self] (senderCell) in
            // 뷰컨트롤러에 있는 세그웨이의 실행
            self?.performSegue(withIdentifier: "edit", sender: indexPath)
        }
```

- cell을 클릭하면 (사용자의 액션) Controller에서 해당 내용을 받아서 작업 처리

### Util

- 앱을 개발함에 있어서 여러 번 사용되거나 유용한 코드를 클래스로 만들어 둔 도구 폴더
