//
//  NetworkManager.swift
//  MVVM
//
//  Created by 이유리 on 2023/07/19.
//

import Foundation

//MARK: - 네트워크에서 발생할 수 있는 에러 정의

enum NetworkError: Error {
    case networkingError
    case dataError
    case parseError
}

//MARK: - Networking (서버와 통신하는) 클래스 모델

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    func getMusic(searchTerm: String, completion: @escaping (Result<[Music], NetworkError>) -> ()) {
        let urlString = "\(MusicApi.requestUrl)\(MusicApi.mediaParam)&term=\(searchTerm)"
        print(urlString)
        
        performRequest(with: urlString) { result in
            completion(result)
        }
        
    }
    
    func performRequest(with urlString: String, completion: @escaping (Result<[Music], NetworkError>) -> ()) {
        
        guard let url = URL(string: urlString) else { return }
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!)
                completion(.failure(.networkingError))
                return
            }
            
            guard let safeData = data else {
                completion(.failure(.dataError))
                return
            }
            
            // 메서드 실행해서, 결과 비동기적으로 전달
            if let musics = self.parseJSON(safeData) {
                completion(.success(musics))
            } else {
                completion(.failure(.parseError))
            }
        }
        task.resume()
    }
    
    private func parseJSON(_ musicData: Data) -> [Music]? {
    
        // 성공
        do {
            let musicData = try JSONDecoder().decode(MusicData.self, from: musicData)
            return musicData.results
        // 실패
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
