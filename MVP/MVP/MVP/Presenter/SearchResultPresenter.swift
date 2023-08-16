//
//  SearchResultPresenter.swift
//  MVP
//
//  Created by 이유리 on 2023/08/16.
//

import Foundation

final class SearchResultPresenter {
    private let service = MainService()
    weak private var delegate: SearchResultProtocol?
    var searchText: String = "" {
        didSet {
            searchKeywordInserted(searchText)
        }
    }
    
    var musicArray: [Music] = [] {
        didSet {
            self.delegate?.displaySearchResult()
        }
    }
    
    func setViewDelegate(delegate: SearchResultProtocol?){
        self.delegate = delegate
    }
    
    func searchKeywordInserted(_ searchText: String) {
        service.searchMusicByTextField(searchTerm: searchText) { result in
            if let result = result {
                self.musicArray = result
            }
        }
    }
}
