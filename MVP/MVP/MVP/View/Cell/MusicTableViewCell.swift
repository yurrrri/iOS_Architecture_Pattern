//
//  MusicTableViewCell.swift
//  MVVM
//
//  Created by 이유리 on 2023/07/19.
//

import UIKit

final class MusicTableViewCell: UITableViewCell {

    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    var imageUrl: String? {
        didSet {
            loadImage()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // 이미지 재사용성 -> 재사용하면서 이전 이미지를 초기화함으로써 이미지를 재사용이 아닌 다시 초기화할 수 있도록 nil 할당
        self.mainImageView.image = nil
    }


    private func loadImage() {
        guard let urlString = self.imageUrl, let url = URL(string: urlString)  else { return }
        
        DispatchQueue.global().async {
        
            guard let data = try? Data(contentsOf: url) else { return }  // 이미지 다운로드
            guard urlString == url.absoluteString else { return }
            
            DispatchQueue.main.async {
                self.mainImageView.image = UIImage(data: data)
            }
        }
    }
}

extension MusicTableViewCell {
    static let id = "MusicTableViewCell"
}
