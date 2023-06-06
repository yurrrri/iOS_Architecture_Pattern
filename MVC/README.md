## MVC

### Tech Stack
- Swift
- CoreData

### 디렉토리 구조
```bash
├── Controller
│   ├── EditViewController.swift
│   └── ViewController.swift
├── Model
│   ├── CoreDataManager.swift
│   ├── ToDoData+CoreDataClass.swift
│   └── ToDoData+CoreDataProperties.swift
├── Util
│   └── MyColor.swift
├── View
└─  └── TodoCell.swift
```

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

### Controller

- Model의 데이터 갱신이나 비즈니스 로직 관련한 내용을 Model에게 요청
- View의 변화가 발생할 시, View에게 업데이트 된 내용 전달

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

- 앱을 개발함에 있어서 여러 번 사용되거나 유용한 코드를 클래스로 만들어 둔 도구 폴더****
