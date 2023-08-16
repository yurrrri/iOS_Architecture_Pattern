//
//  ViewController.swift
//  MVVM
//
//  Created by 이유리 on 2023/07/10.
//

import UIKit

final class MainViewController: UIViewController, MainProtocol {
    
    @IBOutlet weak var musicTableView: UITableView!
    
    var presenter: MainPresenter!   // View는 Presenter를 소유함
    
    // 네비게이션 바에 embed할 search VC
//    let searchController = UISearchController()
    
//     서치 Results컨트롤러
    let searchController = UISearchController(searchResultsController: UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchResultViewController") as! SearchResultViewController)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter = MainPresenter()
        presenter.setViewDelegate(delegate: self)

        setupTableView()
        setupSearchBar()
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
    
    func displaySearchResult() {
        DispatchQueue.main.async {
            self.musicTableView.reloadData()
        }
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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

extension MainViewController: UISearchBarDelegate {

    // 서치바에서 글자를 입력할 때마다 호출되는 메서드
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        print(searchText) // 띄어쓰기가 있으면 "+"를 붙여서 보내야함
        let searchText = searchText.replacingOccurrences(of: " ", with: "+")

        presenter.searchKeywordInserted(searchText: searchText)  // 1) 사용자의 입력이 들어오면, Presenter에게 데이터를 요청함
    }
}

extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print(searchController.searchBar.text ?? "")
        let searchText = searchController.searchBar.text? .replacingOccurrences(of: " ", with: "+") ?? ""

        let nextPresenter = (searchController.searchResultsController as! SearchResultViewController).presenter
        // 다음 화면 Presenter에 찾으려는 단어 전달
        nextPresenter!.searchText = searchText
    }
}
