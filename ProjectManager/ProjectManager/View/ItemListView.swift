import UIKit

class CacheDragCoordinator {
  let sourceIndexPath: IndexPath
  var dragCompleted = false
  var isReordering = false

  init(sourceIndexPath: IndexPath) {
    self.sourceIndexPath = sourceIndexPath
  }
}

class ItemListView: UICollectionView {
    private(set) var state: State
    
    init(state: State, width: CGFloat) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        //layout.estimatedItemSize = CGSize(width: width, height: 100)
        print("🐢\(width)")
        layout.estimatedItemSize.width = width
        layout.headerReferenceSize.width = width
        
        layout.sectionHeadersPinToVisibleBounds = true
        //layout.itemSize = UICollectionViewFlowLayout.automaticSize
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0) // top 10 주면댐
        self.state = state // 이게 밑으로 가면 나는 에러는 왜 나는건지
        super.init(frame: .zero, collectionViewLayout: layout)
        
        register(ItemListCell.self, forCellWithReuseIdentifier: "ItemListCell")
        register(ListHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ListHeaderView")
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemGray6
    }
}
