import Foundation

class TodoList {
    private var items: [Item]
    
    init(items: [Item]) {
        self.items = items
    }
    
    func getTodo(at index: Int) -> Item? {
        guard index < items.count else {
            return nil
        }
        
        return items[index]
    }
    
    func getCount() -> Int {
        items.count
    }
}

extension TodoList {
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
