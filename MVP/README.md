## MVP
> MVC에서 Massive View Controller의 문제를 해결하기 위해 Controller에서 비즈니스 로직을 Presenter로 분리한 패턴

- M : Model
- V : View
- P : Presenter

<img src="https://github.com/yurrrri/iOS_Architecture_Pattern/assets/37764504/8a10dc99-ebb1-4fc5-a87c-01b2cfeb138c" width="500"/>

- View: 사용자의 액션을 Presenter에게 전달, UI 담당 로직 (MVP에서 View는 View와 ViewController 모두 포함)
- Presenter: 이에 따라 Model의 데이터 갱신, 비즈니스 로직을 수행, View 갱신
- Model: Model이 비즈니스 로직에 따라 데이터를 변경하면, 변화 내용을 Presenter에게 전달

**MVP가 부합하는 좋은 아키텍처의 조건** <br/>

장점 : 1. 역할 분리 2. 테스트 용이 <br/>
단점 : 3. 사용성의 경우 간단한 프로젝트에서 사용하기에는 복잡할 수 있음

**🚨 문제점**  <br/>

- Controller의 역할을 Presenter로 분리하는 대신, 여전히 Presenter가 비대하다는 단점이 존재
- Presenter와 View 간의 높은 의존성 문제 --> 이를 ViewModel의 데이터 바인딩을 이용하여 의존성을 해결한 패턴이 MVVM 패턴
- 개인적으로 느끼는 MVVM 패턴에 비해 가지는 단점은, Protocol을 추가적으로 가져서 아키텍처 규모가 상대적으로 비대해지며, Protocol을 통해 View에게 데이터 변경이 발생했음을 한번 더 알려주어야 하는 번거로움이 있다고 느껴짐

## 토이 프로젝트

### Model

- 데이터 모델 담당 <br/>

<img width="500" src="https://github.com/yurrrri/iOS_Architecture_Pattern/assets/37764504/1d6f758e-a44b-44bc-b388-898d09bb11c4" />

### View

- View + ViewController
- UI와 화면에 데이터를 표시하여 UI 표시에 집중
- View는 Presenter에게 사용자의 액션을 전달하며, 결과를 Presenter로부터 전달받아 View를 업데이트

<img width="300" src="https://github.com/yurrrri/iOS_Architecture_Pattern/assets/37764504/19706ab5-1f7b-407f-a6f3-5bea37603681" /> <br/>

1) ViewController는 View를 담당하고, Presenter를 소유함

```swift
final class MainViewController: UIViewController, MainProtocol {  
    
    @IBOutlet weak var musicTableView: UITableView!
    
    var presenter: MainPresenter!   // View는 Presenter를 소유함
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.presenter = MainPresenter()
        presenter.setViewDelegate(delegate: self)

        setupTableView()
        setupSearchBar()
    }
    
    func setupTableView() {   // View는 UI 관련 로직 담당
        //테이블뷰
        musicTableView.dataSource = self
        musicTableView.delegate = self

        // xib로 cell을 만들었을 때 따로 register 과정 필요
        musicTableView.register(UINib(nibName: MusicTableViewCell.id, bundle: nil), forCellReuseIdentifier: MusicTableViewCell.id)
        
        // 유동적인 cell을 위해 필요
        musicTableView.rowHeight = 120
        musicTableView.estimatedRowHeight = UITableView.automaticDimension
        
    }

// 후략
```

2) 비즈니스 로직은 Presenter에게 수행을 시킴 (사용자의 input이 들어오면 이를 Presenter로 전달)

```swift
extension MainViewController: UISearchBarDelegate {

    // 서치바에서 글자를 입력할 때마다 호출되는 메서드
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        print(searchText) // 띄어쓰기가 있으면 "+"를 붙여서 보내야함
        let searchText = searchText.replacingOccurrences(of: " ", with: "+")

        presenter.searchKeywordInserted(searchText: searchText)  // 사용자의 입력이 들어오면, Presenter에게 데이터를 요청함
    }
}
```

### Presenter

- ViewController 당 Presenter 1개
- 보통 Data Provider인 Service를 소유하며, Service로부터 데이터를 전달받으면 해당 데이터를 View에게 전달
- View와 Presenter 간 데이터 전달의 매개체는 Protocol

<img width="400" src="https://github.com/yurrrri/iOS_Architecture_Pattern/assets/37764504/4148b109-19c9-4091-8acb-ab4c0fa21593"/>

1) Protocol --> View와 Presenter 간 매개체 역할 <br/>

```swift
protocol MainProtocol: AnyObject {
    func displaySearchResult()
}
```

2) Presenter는 보통 데이터 전달자인 Service를 소유하며, Service가 데이터를 관리 및 Presenter에게 전달함

```swift
final class MainPresenter {
    private let service = MainService()
    weak private var mainDelegate: MainProtocol?
    
    var musicArray: [Music] = [] {   // 데이터 소유
        didSet {  // Service로부터 데이터를 전달받으면, protocol을 통해 View에게 데이터 변경을 알림
            self.mainDelegate?.displaySearchResult()
        }
    }
    
    func setViewDelegate(delegate: MainProtocol?){
        self.mainDelegate = delegate
    }
    
    func searchKeywordInserted(searchText: String) {
        service.searchMusicByTextField(searchTerm: searchText) { result in   // Service에게 데이터 요청
            if let result = result {
                self.musicArray = result
            }
        }
    }
}
```

3) Service --> 데이터제공자 역할

```swift
final class MainService {  // Service --> Data Provider 역할 (데이터 제공자)

    lazy var networkManager = NetworkManager.shared
 
    // View -> ViewModel (input)
    func searchMusicByTextField(searchTerm: String, callback: @escaping ([Music]?) -> Void) {
        networkManager.getMusic(searchTerm: searchTerm) { result in
            switch result {
                case .success(let musics):
                callback(musics)
                case .failure(let error):
                    switch error {
                        case .dataError:
                            print("데이터 에러")
                        case .networkingError:
                            print("네트워킹 에러")
                        case .parseError:
                            print("파싱 에러")
                    }
                callback(nil)
            }
        }
    }
}
```

4) ViewController는 Protocol을 통해 presenter의 데이터 변경 신호를 받으면, UI를 변경함

```swift
final class MainViewController: UIViewController, MainProtocol {
/// 중략
    func displaySearchResult() {    //presenter의 Protocol(MainProtocol)이 소유하는 메서드 --> Presenter에서 모델의 변화가 생길 때 presenter가 뷰에게 모델의 변화 전달
        DispatchQueue.main.async {
            self.musicTableView.reloadData()
        }
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {  // Presenter가 소유하는 데이터를 기반으로 TableView 그리기
        return presenter.musicArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = musicTableView.dequeueReusableCell(withIdentifier: MusicTableViewCell.id, for: indexPath) as! MusicTableViewCell
        let musicArray = presenter.musicArray
        
        // 이미지를 다운로드 받는일은 오래걸리는 일이기때문에, 먼저 url을 다 전달 받은 다음에 로딩해야함
        cell.imageUrl = musicArray[indexPath.row].imageUrl
        
        cell.songNameLabel.text = musicArray[indexPath.row].songName
        cell.artistNameLabel.text = musicArray[indexPath.row].artistName
        cell.albumNameLabel.text = musicArray[indexPath.row].albumName
        cell.releaseDateLabel.text = musicArray[indexPath.row].releaseDateString
        
        cell.selectionStyle = .none
        
        return cell
    }
}
```

