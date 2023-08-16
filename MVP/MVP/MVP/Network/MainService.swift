//
//  MainService.swift
//  MVP
//
//  Created by 이유리 on 2023/08/16.
//

import Foundation

final class MainService {  // Service --> Data Provider 역할 (데이터 제공자)

    lazy var networkManager = NetworkManager.shared
 
    // View -> ViewModel (input)
    func searchMusicByTextField(searchTerm: String, callback: @escaping ([Music]?) -> Void) {
        networkManager.getMusic(searchTerm: searchTerm) { result in
            switch result {
                case .success(let musics):
                    // 데이터 생성 완료 (API를 통해 다운로드 -> 파싱 완료된)
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
