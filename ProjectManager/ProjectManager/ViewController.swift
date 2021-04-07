import UIKit

class ViewController: UIViewController {
    // array 는 struct 인데 내부가 reference type ..
    private var todosList = TodoList(items: [
        Item(id: 1, title: "무엇이냐", body: "ㅅㅎㅎㅎㅇ?", deadline: Date()),
        Item(id: 2, title: "블라블라", body: "계속블라블라?", deadline: Date()),
        Item(id: 3, title: "난괜차나", body: "", deadline: Date()),
        Item(id: 4, title: "다들참말마나", body: "범범범범?", deadline: Date()),
        Item(id: 5, title: "아킵워킹", body: "딱 좋은것만 ?", deadline: Date()),
        Item(id: 6, title: "바빠", body: "이 맛은 마치?", deadline: Date())
    ])
    private var doingsList = TodoList(items: [
        Item(id: 4, title: "Mymymy", body: "troye sivan", deadline: Date()),
        Item(id: 5, title: "", body: "", deadline: Date()),
        Item(id: 6, title: "sdfsda", body: "", deadline: Date())
    ])
    private var donesList = TodoList(items: [])
    
    private let stackViewSpacing = 10
    
    lazy private var listViewDic: [State:ItemListView] = {
        var dictionary = [State:ItemListView]()
        let spaceCount = State.allCases.count - 1
        let totalSpaceWidth = CGFloat(stackViewSpacing * spaceCount)
        let listViewWidth = (view.frame.size.width - totalSpaceWidth) / CGFloat(State.allCases.count)
        State.allCases.forEach {
            dictionary[$0] = ItemListView(state: $0, width: listViewWidth)
        }
        
        return dictionary
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationItem.title = "Project Manager"
        setupUI()
    }
    
    private func setupUI() {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .lightGray
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        [State.todo, State.doing, State.done].forEach { state in
            guard let list = listViewDic[state] else {
                return
            }
            configureList(list)
            stackView.addArrangedSubview(list)
        }
    }
    
    private func configureList(_ collectionView: ItemListView) {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
    }
}

private extension ViewController {
    func dataSourceForCollectionView(_ collectionView: UICollectionView) -> TodoList {
        guard let collectionView = collectionView as? ItemListView else {
            fatalError()
        }
        
        switch collectionView.state {
        case .todo:
            return todosList
        case .doing:
            return doingsList
        case .done:
            return donesList
        default:
            fatalError() // nil 처리를 앞에서 하면됨
        }
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("select!")
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let collectionView = collectionView as? ItemListView else {
            return 0
        }
        print("numberOfItemsInSection() call!")
        
        //print("현재 todos.count \(todos.count)!")
        return dataSourceForCollectionView(collectionView).getCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let collectionView = collectionView as? ItemListView,
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemListCell", for: indexPath) as? ItemListCell,
              let todo = dataSourceForCollectionView(collectionView).getTodo(at: indexPath.item) else {
            fatalError()
        }
        
        cell.setItem(todo)
        cell.isSelected = true
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .bottom)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        print("header view 설정하는 거")
        guard let collectionView = collectionView as? ItemListView else {
            fatalError("failed to load ItemListView")
        }
        //setNeedsdisplay
        if kind == UICollectionView.elementKindSectionHeader {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ListHeaderView", for: indexPath) as? ListHeaderView else {
                fatalError("failed to load ListHeaderView")
            }
            
            headerView.setupInfo(state: collectionView.state!, count: dataSourceForCollectionView(collectionView).getCount())
            
            return headerView
//        } else if kind == UICollectionView.elementKindSectionFooter {
//            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ListFooterView", for: indexPath)
//            // 높이 설정해주는거
//            footerView.heightAnchor.constraint(equalToConstant: 100).isActive = true
//
//            return footerView
        } else {
            fatalError()
        }
    }
    
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: 50)
    }
}

extension ViewController: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        guard let collectionView = collectionView as? ItemListView else {
            fatalError("failed to load ItemListView")
        }
        print("<1> itemsForBeginning session call!")
        guard let targetItem = dataSourceForCollectionView(collectionView).getTodo(at: indexPath.item) else {
            return []
        }
        print("target item : \(targetItem)")
        
        let itemProvider = NSItemProvider(object: targetItem.title as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = targetItem
        
        let dragCoordinator = CacheDragCoordinator(sourceIndexPath: indexPath)
        session.localContext = dragCoordinator
        
        return [dragItem]
    }
    
    func collectionView(_ collectionView: UICollectionView, dragSessionDidEnd session: UIDragSession) {
        guard let collectionView = collectionView as? ItemListView else {
            return
        }
        print("<4> dragSessionDidEnd call!")
//        var items = [Item]()
//        switch collectionView.state {
//        case .todo:
//            items = todos
//        case .doing:
//            items = doings
//        case .done:
//            items = dones
//        default:
//            break
//        }
        
        guard
          let dragCoordinator = session.localContext as? CacheDragCoordinator,
          dragCoordinator.dragCompleted == true,
          dragCoordinator.isReordering == false
          else {
            return
        }
        print("<4> dragSessionDidEnd - 다른 뷰로 옮겨졌을 때만 지우기!")
        print("옮기기 시작한 collectionView는 \(collectionView.state)")
        let sourceIndexPath = dragCoordinator.sourceIndexPath
        collectionView.performBatchUpdates({
            dataSourceForCollectionView(collectionView).deleteTodo(at: sourceIndexPath.item)
            collectionView.deleteItems(at: [sourceIndexPath])
        })
    }
}


extension ViewController: UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        // 이 메서드가 불리면서 넘어온 drop activity 에 대응하는 drag session 이 있는지
        // 확인하고 없으면 다른 곳에서 넘어온 drag drop 이니까 copy 해줌
        
        print("<2> dropSessionDidUpdate call!")
        guard session.localDragSession != nil,
              session.items.count == 1 else {
            return UICollectionViewDropProposal(operation: .cancel)
        }
        
        return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        guard let collectionView = collectionView as? ItemListView else {
            fatalError("failed to load ItemListView")
        }
        print("<3> performDropWith call!")
        var destinationIndexPath: IndexPath
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            let itemCount = collectionView.numberOfItems(inSection: 0)
            destinationIndexPath = IndexPath(item: itemCount, section: 0)
        }
        
        guard let item = coordinator.items.first else {
            return
        }
        
        if coordinator.proposal.operation == .move {
            guard let dragCoordinator =
              coordinator.session.localDragSession?.localContext as? CacheDragCoordinator
              else { return }
            
            if let sourceIndexPath = item.sourceIndexPath {
                dragCoordinator.isReordering = true
                // 같은 view 내에서의 이동
                collectionView.performBatchUpdates({
                    dataSourceForCollectionView(collectionView).moveTodo(at: sourceIndexPath.item, to: destinationIndexPath.item)
                    collectionView.deleteItems(at: [sourceIndexPath])
                    collectionView.insertItems(at: [destinationIndexPath])
                })
            } else {
                dragCoordinator.isReordering = false
                // 다른 views 간의 이동
                print("목적지 collectionView는 \(collectionView.state)")
                if let thing = item.dragItem.localObject as? Item {
                    collectionView.performBatchUpdates ({
                        dataSourceForCollectionView(collectionView).addTodo(thing, at: destinationIndexPath.item)
                        collectionView.insertItems(at: [destinationIndexPath])
                    })
                }
            }
            dragCoordinator.dragCompleted = true
            coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
        }
    }
}
