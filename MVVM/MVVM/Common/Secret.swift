//
//  Secret.swift
//  MVVM
//
//  Created by 이유리 on 2023/07/19.
//

import Foundation

//MARK: - NameSpace
// 여기에 gitignore에 들어가야하는 보안 관련 사항들 추가

// 생성자 없이 Constant 속성을 접근하고자 할 경우 enum을 만들면 편함
enum MusicApi {
    static let requestUrl = "https://itunes.apple.com/search?"
    static let mediaParam = "media=music"
}
