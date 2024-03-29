//
//  MusicCollectionViewCell.swift
//  MVVM
//
//  Created by 이유리 on 2023/07/19.
//

import UIKit

final class MusicCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    var imageUrl: String? {
        didSet {
            loadImage()
        }
    }
    
    private func loadImage() {
        guard let urlString = self.imageUrl, let url = URL(string: urlString)  else { return }
        
        DispatchQueue.global().async {
            // 이미지 다운로드는 오래걸리므로 비동기 처리
            guard let data = try? Data(contentsOf: url) else { return }
            
            guard urlString == url.absoluteString else { return }
            
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: data)
            }
        }
    }
    
    // 셀이 재사용되기 전에 호출되는 메서드
    override func prepareForReuse() {
        super.prepareForReuse()
        // 이미지 재사용 이슈로 인해서 초기화 필요
        self.imageView.image = nil
    }
}


// 컬렉션뷰 구성을 위한 설정
extension MusicCollectionViewCell {
    static let spacingWitdh: CGFloat = 1
    static let cellColumns: CGFloat = 3
    static let id = "MusicCollectionViewCell"
}

