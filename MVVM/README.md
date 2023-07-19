## MVVM

<img src="https://github.com/yurrrri/iOS_Architecture_Pattern/assets/37764504/d91f6996-ea27-46e9-905d-fd2e1be6bd8f" width="700"/>

- Model: 데이터 모델 (기준 MVC 패턴에서 비즈니스 로직이 ViewModel로 분리된 형태)
- View: View와 Controller를 합쳐서 하나의 View로 보고, View는 사용자의 input을 viewModel에 전달하고 표시하는 역할
- ViewModel: 뷰를 위한 데이터 모델 역할을 하며, Model을 소유하며 전반적인 비즈니스 로직을 담당한다. 이를 통해 View의 변화가 발생할 시 View에 전달

 **바인딩** <br/>

- 뷰 모델을 통해 일어난 변화를 뷰가 반영하는 것
- 알리는 방법으로는 KVO, 이스케이핑 클로저, Notification 등이 있고
- 서드파티 라이브러리를 활용해 편리하게 바인딩을 구현하는 방법으로 RxSwift, Combine이 있음

**MVVM과 RxSwift가 서로 잘 어울리는 이유** <br/>
- RxSwift의 핵심은 특정 클래스의 변화를 관찰하고 있다가 이 변화를 뷰에 바인딩함에 있으므로, 뷰 모델에서 일어난 변화를 바로 뷰에 반영하기에 로직이 어울림


**MVVM이 부합하는 좋은 아키텍처의 조건** <br/>

장점 : 1. 역할 분리 2. 테스트 용이 <br/>
단점 : 3. 사용성의 경우 간단한 프로젝트에서 사용하기에는 복잡할 수 있음

**🚨 문제점**  <br/>

아키텍처에 정답은 없듯이, MVVM도 마찬가지로 단점이 존재한다. <br/>
바로 MVC 패턴에서 문제였던 Massive View Controller와 마찬가지로, ViewModel이 비대해지는 Massive View Model이 단점으로 지적된다.

이를 보완한 아키텍처들은 아래와 같은 것들이 있다.

- VIPER
- RIBs
- Clean Architecture

그리고 MVVM을 통해 Controller의 역할을 분리했음에도 여전히 비중이 컸던 ViewController의 화면 전환, 화면 간 데이터 전달 등의 책임을 Coordinator로 분리한 패턴인 MVVM-C 아키텍처도 존재한다.
- MVVM-C

## 토이 프로젝트
### Model

- 데이터 모델 <br/>
<img width="500" src="https://github.com/yurrrri/iOS_Architecture_Pattern/assets/37764504/1d6f758e-a44b-44bc-b388-898d09bb11c4" />

```swift
// 순수 데이터 모델만 존재함
struct MusicData: Codable {
    let resultCount: Int
    let results: [Music]
}
// 후략
```

### View

- View + ViewController
- UI와 화면에 데이터를 표시하는 로직
- 로직에 따른 UI 변경 내용을 반영

<img width="300" src="https://github.com/yurrrri/iOS_Architecture_Pattern/assets/37764504/19706ab5-1f7b-407f-a6f3-5bea37603681" /> <br/>

1) 화면에 뿌릴 viewModel로부터 가져옴

```swift
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.musicArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = musicTableView.dequeueReusableCell(withIdentifier: MusicTableViewCell.id, for: indexPath) as! MusicTableViewCell
        let musicArrays = viewModel.musicArray
        
        // 이미지를 다운로드 받는일은 오래걸리는 일이기때문에, 먼저 url을 다 전달 받은 다음에 로딩해야함
        cell.imageUrl = musicArrays[indexPath.row].imageUrl
        
        cell.songNameLabel.text = musicArrays[indexPath.row].songName
        cell.artistNameLabel.text = musicArrays[indexPath.row].artistName
        cell.albumNameLabel.text = musicArrays[indexPath.row].albumName
        cell.releaseDateLabel.text = musicArrays[indexPath.row].releaseDateString
        
        cell.selectionStyle = .none
        
        return cell
    }
}
```

2) 비즈니스 로직은 ViewModel에게 수행을 시킴 (사용자의 input이 들어오면 이를 ViewModel로 전달)

```swift
extension ViewController: UISearchBarDelegate {

    // 서치바에서 글자를 입력할 때마다 호출되는 메서드
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        print(searchText) // 띄어쓰기가 있으면 "+"를 붙여서 보내야함
        let searchText = searchText.replacingOccurrences(of: " ", with: "+")

        viewModel.searchMusicByTextField(searchTerm: searchText)  // viewModel에게 데이터를 찾도록 요청 --> viewModel이 비즈니스로직 실행하도록
    }
}
```

### ViewModel

- 뷰에 관한 비즈니스 로직 담당
- ViewController 당 ViewModel 1개

<img width="400" src="https://github.com/yurrrri/iOS_Architecture_Pattern/assets/37764504/35917c5d-57e8-41c3-9b03-b2a75e4daec4"/>

1) 비즈니스 로직 완성 후 데이터를 ViewController에게 알림 (onCompleted)

```swift
final class ViewModel {
    lazy var networkManager = NetworkManager.shared
    
    // 뷰를 위한 데이터 (Output)
    // 테이블뷰를 뿌릴 데이터 -> ViewModel이 Model 소유
    var musicArray: [Music] = [] {
        didSet {
            onCompleted(self.musicArray)   // 데이터가 받아와지면 onCompleted 실행 --> ViewController에서 정의한대로 화면에 뿌려주는 동작 실행
        }
    }
    
    var onCompleted: ([Music]) -> Void = { _ in }
    
    // View -> ViewModel (input)
    func searchMusicByTextField(searchTerm: String) {
        networkManager.getMusic(searchTerm: searchTerm) { [weak self] result in
            switch result {
                case .success(let musics):
                    // 데이터 생성 완료 (API를 통해 다운로드 -> 파싱 완료된)
                self?.musicArray = musics
                case .failure(let error):
                    switch error {
                        case .dataError:
                            print("데이터 에러")
                        case .networkingError:
                            print("네트워킹 에러")
                        case .parseError:
                            print("파싱 에러")
                    }
            }
        }
    }
}
```

2) ViewController는 ViewModel로부터 데이터의 변화를 전달받으면 (onCompleted) --> UI도 변화시킴

```swift
    private func viewModelOutPut() {
        self.viewModel.onCompleted = { _ in
            DispatchQueue.main.async {  // 데이터가 불러와지면 -> reloadData
                self.musicTableView.reloadData()
            }
        }
    }
```
