import Foundation
import CoreData

class ToDoItem: NSManagedObject, Identifiable {
    @NSManaged var name: String?
    @NSManaged var createdAt: Date?
}

extension ToDoItem {
    static func getAllToDoListItems() -> NSFetchRequest<ToDoItem> {
        let request: NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest() as! NSFetchRequest<ToDoItem>
        let sort = NSSortDescriptor(key: "createdAt", ascending: true)
        request.sortDescriptors = [sort]
        return request
    }
}


