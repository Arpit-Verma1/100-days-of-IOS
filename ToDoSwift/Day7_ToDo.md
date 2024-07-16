# 100 Days of iOS Development with Swift

Welcome to my 100 Days of iOS Development journey! Each day, I will be documenting my learnings and progress as I dive deeper into iOS development using Swift.

## Day 7: Creating a To-Do App with Core Data

### What I Learned
Today, I learned how to create a simple To-Do app using Core Data for persistent storage. I declared a `ToDoItem` as a data model with `name` and `createdAt` attributes. Instead of using Codegen, I chose the manual option and defined the `ToDoItem` class manually.

### Key Concepts
- **Core Data**: A framework for managing the model layer objects in a Swift application.
- **NSManagedObject**: A base class that implements the behavior required of a Core Data model object.
- **NSFetchRequest**: A description of search criteria used to retrieve data from a persistent store.

### Declaring the ToDoItem Model
Here is the code for declaring the `ToDoItem` model:
![WhatsApp Image 2024-07-16 at 5 55 07 PM](https://github.com/user-attachments/assets/d37ef3a0-bfba-49e8-a662-5ebf64df5a70)


```swift
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
