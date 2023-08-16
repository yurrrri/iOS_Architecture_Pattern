//
//  SearchResultViewModel.swift
//  MVVM
//
//  Created by 이유리 on 2023/07/19.
//

import Foundation

final class SearchResultViewModel {
    lazy var networkManager = NetworkManager.shared
    
    // 뷰를 위한 데이터 (Output)
    // 테이블뷰를 뿌릴 데이터 -> ViewModel이 Model 소유
    var searchTerm: String? {
        didSet {
            searchMusicByTextField(searchTerm: self.searchTerm ?? "")
        }
    }
    
    var musicArray: [Music] = [] {
        didSet {
            onCompleted(self.musicArray)   // 데이터가 받아와지면 onCompleted 실행
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
