import UIKit

class TodoListController: UIViewController {
    // array 는 struct 인데 내부가 reference type ..
    private var todosList = TodoListDataSource(state: .todo, items: [
        Item(id: 1, title: "무엇이냐", body: "ㅅㅎㅎㅎㅇ?", deadline: Date(), state: .todo),
        Item(id: 2, title: "블라블라", body: "계속블라블라?", deadline: Date(), state: .todo),
        Item(id: 3, title: "난괜차나", body: "", deadline: Date(), state: .todo),
        Item(id: 4, title: "다들참말마나", body: "범범범범?", deadline: Date(), state: .todo),
        Item(id: 5, title: "아킵워킹", body: "딱 좋은것만 ?", deadline: Date(), state: .todo),
        Item(id: 6, title: "바빠", body: "이 맛은 마치?", deadline: Date(), state: .todo)
    ])
    private var doingsList = TodoListDataSource(state: .doing, items: [
        Item(id: 4, title: "Mymymy", body: "troye sivan", deadline: Date(), state: .doing),
        Item(id: 5, title: "sdfsd", body: "", deadline: Date(), state: .doing),
        Item(id: 6, title: "sdfsda", body: "", deadline: Date(), state: .doing)
    ])
    private var donesList = TodoListDataSource(state: .done, items: [])
    
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
        setupNavigationBar()
        setupUI()
    }
    
    private func setupNavigationBar() {
        title = "Project Manager"
        navigationController?.isToolbarHidden = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
//        navigationController?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))
    }
    
    @objc private func addTapped() {
        let detailViewController = UINavigationController(rootViewController: TodoDetailController(addOnly: true))
        //present(detailViewController, animated: true, completion: nil)
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
        collectionView.dataSource = dataSourceForCollectionView(collectionView)
        collectionView.delegate = self
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
    }
}

private extension TodoListController {
    func dataSourceForCollectionView(_ collectionView: UICollectionView) -> TodoListDataSource {
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
        }
    }
}

extension TodoListController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedItem = dataSourceForCollectionView(collectionView).getTodo(at: indexPath.item) else {
            return
        }
        let detailViewController = UINavigationController(rootViewController: TodoDetailController(todo: selectedItem, addOnly: false))
        present(detailViewController, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, canEditItemAt indexPath: IndexPath) -> Bool {
        true
    }
}

extension TodoListController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: 55)
    }
}

extension TodoListController: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        guard let collectionView = collectionView as? ItemListView else {
            fatalError("failed to load ItemListView")
        }
        
        let dragCoordinator = CacheDragCoordinator(sourceIndexPath: indexPath)
        session.localContext = dragCoordinator
        
        let dataSource = dataSourceForCollectionView(collectionView)
        return dataSource.dragItems(for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, dragSessionDidEnd session: UIDragSession) {
        guard let collectionView = collectionView as? ItemListView else {
            return
        }
        
        guard
          let dragCoordinator = session.localContext as? CacheDragCoordinator,
          dragCoordinator.dragCompleted == true,
          dragCoordinator.isReordering == false
          else {
            return
        }
        
        let sourceIndexPath = dragCoordinator.sourceIndexPath
        collectionView.performBatchUpdates({
            dataSourceForCollectionView(collectionView).deleteTodo(at: sourceIndexPath.item)
            collectionView.deleteItems(at: [sourceIndexPath])
            updateHeaderView(of: collectionView)
        })
        
        //collectionView.collectionViewLayout.invalidateLayout()
    }
}


extension TodoListController: UICollectionViewDropDelegate {
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
                    updateHeaderView(of: collectionView)
                })
            } else {
                dragCoordinator.isReordering = false
                // 다른 views 간의 이동
                if var thing = item.dragItem.localObject as? Item {
                    thing.state = collectionView.state
                    collectionView.performBatchUpdates ({
                        dataSourceForCollectionView(collectionView).addTodo(thing, at: destinationIndexPath.item)
                        collectionView.insertItems(at: [destinationIndexPath])
                        updateHeaderView(of: collectionView)
                    })
                }
            }
            dragCoordinator.dragCompleted = true
            coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
            
        }
    }
}

extension TodoListController {
    private func updateHeaderView(of collectionView: ItemListView) {
        //collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: .init(item: 0, section: 0))
        if let supplementaryView = collectionView.visibleSupplementaryViews(ofKind: UICollectionView.elementKindSectionHeader).first,
           let headerView = supplementaryView as? ListHeaderView {
            dataSourceForCollectionView(collectionView).updateHeaderView(headerView)
        }
    }
}
