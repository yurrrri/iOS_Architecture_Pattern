//
//  ViewModel.swift
//  MVVM
//
//  Created by 이유리 on 2023/07/19.
//

import Foundation

final class MainPresenter {
    private let service = MainService()
    weak private var mainDelegate: MainProtocol?
    
    var musicArray: [Music] = [] {
        didSet {
            self.mainDelegate?.displaySearchResult()
        }
    }
    
    func setViewDelegate(delegate: MainProtocol?){
        self.mainDelegate = delegate
    }
    
    func searchKeywordInserted(searchText: String) {
        service.searchMusicByTextField(searchTerm: searchText) { result in
            if let result = result {
                self.musicArray = result
            }
        }
    }
}
