//
//  ViewController.swift
//  MVVM
//
//  Created by 이유리 on 2023/07/10.
//

import UIKit

final class ViewController: UIViewController {
    
    @IBOutlet weak var musicTableView: UITableView!
    
    var viewModel: ViewModel!   // View는 ViewModel에 의존함
    
    // 네비게이션 바에 embed할 search VC
//    let searchController = UISearchController()
    
    // 서치 Results컨트롤러
    let searchController = UISearchController(searchResultsController: UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchResultViewController") as! SearchResultViewController)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = ViewModel()

        setupTableView()
        setupSearchBar()
        
        viewModelOutPut()
    }
    
    private func viewModelOutPut() {
        self.viewModel.onCompleted = { _ in
            DispatchQueue.main.async {  // 데이터가 불러와지면 -> reloadData
                self.musicTableView.reloadData()
            }
        }
    }
    
    func setupTableView() {
        //테이블뷰
        musicTableView.dataSource = self
        musicTableView.delegate = self

        // xib로 cell을 만들었을 때 따로 register 과정 필요
        musicTableView.register(UINib(nibName: MusicTableViewCell.id, bundle: nil), forCellReuseIdentifier: MusicTableViewCell.id)
        
        // 유동적인 cell을 위해 필요
        musicTableView.rowHeight = 120
        musicTableView.estimatedRowHeight = UITableView.automaticDimension
        
    }
    
    // 서치바 셋팅
    func setupSearchBar() {
        self.title = "Music Search"
        navigationItem.searchController = searchController
        
        // 1) 네비게이션 바에서 서치바의 사용
//        searchController.searchBar.delegate = self
        
        
        // 2) 서치(결과)컨트롤러의 사용
        searchController.searchResultsUpdater = self
        
        // 첫글자 대문자 설정 없애기
        searchController.searchBar.autocapitalizationType = .none
    }
}

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

extension ViewController: UISearchBarDelegate {

    // 서치바에서 글자를 입력할 때마다 호출되는 메서드
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        print(searchText) // 띄어쓰기가 있으면 "+"를 붙여서 보내야함
        let searchText = searchText.replacingOccurrences(of: " ", with: "+")

        viewModel.searchMusicByTextField(searchTerm: searchText)  // viewModel에게 데이터를 찾도록 요청 --> viewModel이 비즈니스로직 실행하도록
    }
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print(searchController.searchBar.text ?? "")
        let searchText = searchController.searchBar.text? .replacingOccurrences(of: " ", with: "+")

        let nextViewModel = (searchController.searchResultsController as! SearchResultViewController).viewModel
        // 컬렉션뷰에 찾으려는 단어 전달
        nextViewModel!.searchTerm = searchText
    }
}
