//
//  CodableBootCamp.swift
//  SwiftInterMediateBootCamp
//
//  Created by Arpit Verma on 05/12/24.
//

import SwiftUI


///Codable = Encodable + Decodable

struct  CustomerModel : Identifiable, Codable {
    let id : String
    let name : String
    let points : Int
    let isPremium : Bool
    
    // this all handle if we use codable instead of encodle,decodable
    
//    enum CodingKeys : String , CodingKey {
//        case id
//        case name
//        case points
//        case isPremium
//    }
//    
//    init (id : String , name : String , points : Int , isPremium : Bool) {
//        self.id = id
//        self.name = name
//        self.points = points
//        self.isPremium = isPremium
//    }
//    
//    init(from decoder : Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.id = try container.decode(String.self, forKey: .id)
//        self.name = try container.decode(String.self, forKey: .name)
//        self.points = try container.decode(Int.self, forKey: .points)
//    }
//    
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(id, forKey: .id)
//        try container.encode(name, forKey: .name)
//        try container.encode(points, forKey: .points)
//    }
}

class CodableViewModel : ObservableObject {
    @Published var customers : CustomerModel? = nil
    init() {
        getData()
    }
    
    func getData() {
        guard let data = getJSONData() else { return }
        //        print("JSON DATA : \(data)")
        //
        //        let jsonString = String(data: data, encoding: .utf8)
        
        do {
            self.customers = try JSONDecoder().decode(CustomerModel.self, from: data)
        }
        catch let error {
            print("error : \(error)")
        }
        
        
//        Manual decoding
//        if
//            let localData = try? JSONSerialization.jsonObject(with: data, options: []),
//            let dictionary = localData as? [String: Any],
//            let id = dictionary["id"] as? String,
//            let name = dictionary["name"] as? String,
//            let points = dictionary["points"] as? Int,
//            let isPremium = dictionary["isPremium"] as? Bool {
//            let newCustomer = CustomerModel(id: id, name: name, points: points, isPremium: isPremium)
//            customers = newCustomer
//        }
        
    }
    
    func getJSONData()-> Data? {
        let customer = CustomerModel(id: "1", name: "Arpit", points: 100, isPremium: true)
        let data = try? JSONEncoder().encode(customer)
        
//        Manual Encoding
//        let dictionary : [String: Any] = [
//            "id":"1"
//            ,"name":"Arpit"
//            ,"points":100
//            ,"isPremium":true
//        ]
//        let data = try? JSONSerialization.data(withJSONObject: dictionary, options: [])
        
        return data
    }
        
}

struct CodableBootCamp: View {
    @StateObject var vm = CodableViewModel()
    var body: some View {
        VStack {
            if let customer = vm.customers {
                Text("\(customer.name)")
                Text("\(customer.points)")
            }
        }
    }
}

#Preview {
    CodableBootCamp()
}
