import SwiftUI

struct FruitsModel: Identifiable {
    let id: String = UUID().uuidString
    let fruitName: String
    let count: Int
}

class FruitViewModel: ObservableObject {  // Step 1: Conform to ObservableObject
    @Published var fruits: [FruitsModel] = []
    @Published var isLoading : Bool  = false
    
    init () {
        onShow()
    }
    
    func deleteFruit(index: IndexSet) {
        fruits.remove(atOffsets: index)
    }
    
    func onShow() {
    isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now()+3.0, execute: {
           
            let fruit1 = FruitsModel(fruitName: "apple", count: 1)
            let fruit2 = FruitsModel(fruitName: "banana", count: 32)
            self.fruits.append(fruit1)
            self.fruits.append(fruit2)
            
            self.isLoading = false
        })
        
    }
}

struct ViewModelBootCamp: View {
    
    /// @ObservedObject chnages if view is updated
    /// @StateObject persist the data if view is changed
    @StateObject var fruitViewModel: FruitViewModel = FruitViewModel()  // Step 2: Use @ObservedObject
    
    var body: some View {
        NavigationView {
            List {
                if fruitViewModel.isLoading {
                    ProgressView()
                }
                else {
                    ForEach(fruitViewModel.fruits) { fruit in
                        Text(fruit.fruitName)
                    }
                    .onDelete(perform: fruitViewModel.deleteFruit)
                }
                
            }
            
            .navigationBarItems(trailing: NavigationLink(destination:secondScr(
            fruitViewModel: fruitViewModel
            ), label: { Image(systemName: "arrow.right")}))
            .navigationTitle("Fruit List")
        }
    }
}

struct  secondScr : View {
    @ObservedObject var fruitViewModel : FruitViewModel
    var body: some View {
        ZStack {
            Color.red.ignoresSafeArea()
            List {
                ForEach(fruitViewModel.fruits) { fruit in
                    Text(fruit.fruitName)
                }
                .onDelete(perform: fruitViewModel.deleteFruit)
            }
        }
    }
}

#Preview {
    ViewModelBootCamp()
}

