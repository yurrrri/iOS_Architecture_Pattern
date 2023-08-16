//
//  SearchResultViewController.swift
//  MVVM
//
//  Created by 이유리 on 2023/07/19.
//

import UIKit

final class SearchResultViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var viewModel: SearchResultViewModel!   // View는 ViewModel에 의존함
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = SearchResultViewModel()

        setupCollectionView()
        viewModelOutPut()
    }
    
    private func viewModelOutPut() {
        self.viewModel.onCompleted = { _ in
            DispatchQueue.main.async {  // 데이터가 불러와지면 -> reloadData
                self.collectionView.reloadData()
            }
        }
    }

    func setupCollectionView() {
        // 컬렉션뷰의 레이아웃을 담당하는 객체
        let flowLayout = UICollectionViewFlowLayout()
        
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        // 컬렉션뷰의 스크롤 방향 설정
        flowLayout.scrollDirection = .vertical
        
        let spacingWidth = MusicCollectionViewCell.spacingWitdh
        let collectionCellWidth = (UIScreen.main.bounds.width - spacingWidth * (MusicCollectionViewCell.cellColumns - 1)) / MusicCollectionViewCell.cellColumns
        
        flowLayout.itemSize = CGSize(width: collectionCellWidth, height: collectionCellWidth)
        // 아이템 사이 간격 설정
        flowLayout.minimumInteritemSpacing = spacingWidth
        // 아이템 위아래 사이 간격 설정
        flowLayout.minimumLineSpacing = spacingWidth
        
        // 컬렉션뷰의 속성에 할당
        collectionView.collectionViewLayout = flowLayout
    }
    
}

extension SearchResultViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.musicArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MusicCollectionViewCell.id, for: indexPath) as! MusicCollectionViewCell
        cell.imageUrl = viewModel.musicArray[indexPath.item].imageUrl
        
        return cell
    }
    
}

