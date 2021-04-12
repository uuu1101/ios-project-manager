import UIKit

// 뭐를 먼저쓰더라 ? super 인거 먼저쓰나?// class 먼저 쓴다
class TodoListDataSource: NSObject, UICollectionViewDataSource {
    private var items: [Item]
    private let state: State
    
    init(state: State, items: [Item]) {
        self.state = state
        self.items = items
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let collectionView = collectionView as? ItemListView,
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemListCell", for: indexPath) as? ItemListCell else {
            fatalError()
        }
        
        cell.setItem(items[indexPath.item])
        cell.isSelected = true
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .bottom)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let collectionView = collectionView as? ItemListView else {
            fatalError("failed to load ItemListView")
        }
        //setNeedsdisplay
        if kind == UICollectionView.elementKindSectionHeader {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ListHeaderView", for: indexPath) as? ListHeaderView else {
                fatalError("failed to load ListHeaderView")
            }
            
            headerView.setupInfo(state: collectionView.state, count: items.count)
            
            return headerView
        } else {
            fatalError()
        }
    }
}

extension TodoListDataSource {
    func dragItems(for indexPath: IndexPath) -> [UIDragItem] {
        let todo = items[indexPath.item]
        let itemProvider = NSItemProvider(object: todo.title as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = todo
        return [dragItem]
    }
    
    func getTodo(at index: Int) -> Item? {
        guard index < items.count else {
            return nil
        }
        
        return items[index]
    }
    
    func addTodo(_ newTodo: Item, at index: Int) {
        items.insert(newTodo, at: index)
    }
    
    func moveTodo(at sourceIndex: Int, to destinationIndex: Int) {
        guard sourceIndex != destinationIndex else { return }
        
        let item = items[sourceIndex]
        items.remove(at: sourceIndex)
        items.insert(item, at: destinationIndex)
    }
    
    func deleteTodo(at index: Int) {
        items.remove(at: index)
    }
}

extension TodoListDataSource {
    func updateHeaderView(_ headerView: ListHeaderView) {
        headerView.updateCount(items.count)
    }
}
