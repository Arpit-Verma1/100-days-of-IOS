//
//  coreDataRelationshipBootCamp.swift
//  SwiftInterMediateBootCamp
//
//  Created by Arpit Verma on 02/12/24.
//

import SwiftUI
import   CoreData


class CoreDataManager {
    static let instance = CoreDataManager()
    let  container : NSPersistentContainer
    let context : NSManagedObjectContext
    
    private init() {
        container = NSPersistentContainer(name: "coreDataContainer")
        container.loadPersistentStores { description, error in
            if let error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        context = container.viewContext
    }
    func save () {
        do
        {
            try  context.save()
            
        }catch  let error {
            print(error)
        }
    }
    
}

class CoreDataRelationshipViewModel: ObservableObject {
    
    let manager = CoreDataManager.instance
    @Published var business: [BusinessEntity] = []
    @Published var departments : [DepartmentEntity] = []
    @Published var employees : [EmplyoeeEntity] = []
    
    
    
    init () {
        getBusiness()
        getDepartments()
        getBusinessEmployees()
    }
    
    func getBusiness() {
        let request = NSFetchRequest<BusinessEntity>(entityName : "BusinessEntity")
        
        do {
            business = try manager.context.fetch(request)
        } catch {
            print(error)
        }
    }
    
    
    func getDepartments() {
        let request = NSFetchRequest<DepartmentEntity>(entityName : "DepartmentEntity")
        
        do {
            departments = try manager.context.fetch(request)
        } catch {
            print(error)
        }
    }
    
    
    
    func getBusinessEmployees() {
        let request = NSFetchRequest<EmplyoeeEntity>(entityName : "EmplyoeeEntity")
        
        do {
            employees = try manager.context.fetch(request)
        } catch {
            print(error)
        }
    }
    
    
    func addBusiness() {
        let newBusiness = BusinessEntity(context: manager.context)
        newBusiness.name = "Apple"
        // add existing departments to the new business
        // newBusiness.departments = []
        
        //add existing emplyee to the new business
        // newbusiees.emplyees = []
        
        //add new buisness to existing departments
        //newbusiness.addtodepartments(value: departmententity)
        
        //add new business to existing employee
        //newbusiness.addToEmployess(value: EmplyeeEnttity)
        
        save()
    }
   
    func addDepartment() {
        let newDepartment = DepartmentEntity(context: manager.context)
        newDepartment.name = "Marketing"
        newDepartment.businesses = [business[0]]
        save()
        
    }
    
    
    func addEmployee() {
        let newEmployee = EmplyoeeEntity(context: manager.context)
        newEmployee.name = "John"
        newEmployee.age = 20
        newEmployee.dateJoined = Date()
        
        newEmployee.business = business[0]
        newEmployee.department = departments[0]
        save()
        
    }
    
    
    func save() {
        business.removeAll()
        departments.removeAll()
        employees.removeAll()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.manager.save()
            self.getBusiness()
            self.getDepartments()
            self.getBusinessEmployees()
        }
        
        
    }
}

struct coreDataRelationshipBootCamp: View {
    @StateObject var viewModel = CoreDataRelationshipViewModel()
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Button(action: viewModel.addEmployee) {
                        Text("Add Business")
                            .foregroundColor(.white)
                            .frame(height: 50)
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding()
                    
                    ScrollView(.horizontal, showsIndicators: true) {
                        HStack(alignment: .top) {
                            ForEach(viewModel.business) { business in
                                BusinessView(entity: business)
                                
                            }
                        }.padding()
                       
                    }
                    ScrollView(.horizontal, showsIndicators: true) {
                        HStack(alignment: .top) {
                            ForEach(viewModel.departments) { department in
                                DepartmentView(entity: department)
                                
                            }
                        }
                       
                    }.padding()
                    ScrollView(.horizontal, showsIndicators: true) {
                        HStack(alignment: .top) {
                            ForEach(viewModel.employees) { emoloyee in
                                EmployeeView (entity: emoloyee)
                                
                            }
                        }
                       
                    }.padding()

                }
            }
            .navigationTitle("CoreData Relationship")
        }
    }
}


struct BusinessView : View {
    let entity : BusinessEntity
    var body : some View {
        VStack {
            Text("entity name \(entity.name ?? " ")")
            if let departments = entity.departments?.allObjects as? [DepartmentEntity] {
                Text("departments:")
                    .bold()
                    
                    ForEach(departments) { department in
                        Text("\(department.name ?? " ")")
                    }
                }
            if let employees = entity.employees?.allObjects as? [ EmplyoeeEntity]{
                Text("employees:")
                    .bold()
                ForEach(employees) { employee in
                    Text("\(employee.name ?? " ")")
                }
            }
        }
        .padding()
        .frame(maxWidth: 300, alignment: .leading)
        .background(Color.gray.opacity(0.5))
        .cornerRadius(10)
        .shadow(radius: 10)

    }
}

struct DepartmentView : View {
    let entity : DepartmentEntity
    var body : some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Department name \(entity.name ?? " ")")
            if let businesses = entity.businesses?.allObjects as? [BusinessEntity] {
                Text("Businesses:")
                    .bold()
                    
                ForEach(businesses) { business in
                        Text("\(business.name ?? " ")")
                    }
                }
            if let employees = entity.employees?.allObjects as? [ EmplyoeeEntity]{
                Text("employees:")
                    .bold()
                ForEach(employees) { employee in
                    Text("\(employee.name ?? " ")")
                }
            }
        }
        .padding()
        .frame(maxWidth: 300, alignment: .leading)
        .background(Color.green.opacity(0.5))
        .cornerRadius(10)
        .shadow(radius: 10)
    }
}


struct EmployeeView : View {
    let entity : EmplyoeeEntity
    var body : some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Name: \(entity.name ?? " ")")
            Text("Age: \(entity.age ?? 0) " )
        Text("Date Joines: \(entity.dateJoined ?? Date()) " )
            
            Text("Businesses:")
                .bold()
            
            Text(entity.business?.name ?? " ")
            
            
            Text("Departments:")
                .bold()
            Text("\(entity.department?.name ?? " ")")
        
        }
        .padding()
        .frame(maxWidth: 300, alignment: .leading)
        .background(Color.blue.opacity(0.5))
        .cornerRadius(10)
        .shadow(radius: 10)
    }
}



#Preview {
    coreDataRelationshipBootCamp()
}
