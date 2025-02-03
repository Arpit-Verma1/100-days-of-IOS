//
//  UserManager.swift
//  FireBaseBootCamp
//
//  Created by Arpit Verma on 26/01/25.
//

import Foundation
import FirebaseFirestore


struct  DBUser : Codable {
    let userId : String
    let isAnonymous : Bool? 
    let email : String?
    let photoUrl : String?
    let dateCreated : Date?
    let isPremium : Bool?
    
    
    init(auth : AuthDataResultModel) {
        self.userId = auth.uid
        self.isAnonymous = auth.uid.isEmpty
        self.email = auth.email
        self.photoUrl = auth.photoUrl
        self.dateCreated = Date()
        self.isPremium = false 
    
    }
    
    init( userId : String,
     isAnonymous : Bool?,
    email : String?,
     photoUrl : String?,
    dateCreated : Date?,
          isPremium : Bool?) {
        self.userId = userId
        self.isAnonymous = isAnonymous
        self.email = email
        self.photoUrl = photoUrl
        self.dateCreated = dateCreated
        self.isPremium = isPremium
    }
    
    
//    mutating func togglePremiumStatus () {
//        let currentValue = isPremium ?? false
//        isPremium = !currentValue
//    }
    
    
    
    enum CodingKeys: String , CodingKey {
        case userId = "user_id"
        case isAnonymous = "is_anonymous"
        case email = "email"
        case photoUrl = "photo_url"
        case dateCreated = "date_created"
        case isPremium = "user_isPremium "
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.isAnonymous = try container.decodeIfPresent(Bool.self, forKey: .isAnonymous)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.photoUrl = try container.decodeIfPresent(String.self, forKey: .photoUrl)
        self.dateCreated = try container.decodeIfPresent(Date.self, forKey: .dateCreated)
        self.isPremium = try container.decodeIfPresent(Bool.self, forKey: .isPremium)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userId, forKey: .userId)
        try container.encodeIfPresent(self.isAnonymous, forKey: .isAnonymous)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.photoUrl, forKey: .photoUrl)
        try container.encodeIfPresent(self.dateCreated, forKey: .dateCreated)
        try container.encodeIfPresent(self.isPremium, forKey: .isPremium)
    }
    
    
    
}




final class UserManager {
    
    static let shared = UserManager()
    private init() {}
    
    private let userCollection = Firestore.firestore().collection("users")
    private func userDocument(userId: String)-> DocumentReference {
        userCollection.document(userId)
    }
    
    
//    private let encoder : Firestore.Encoder = {
//        let encoder = Firestore.Encoder()
//        encoder.keyEncodingStrategy = .convertToSnakeCase
//        return encoder
//    }()
//    
//    private let decoder : Firestore.Decoder = {
//        let decoder = Firestore.Decoder()
//        decoder.keyDecodingStrategy = .convertFromSnakeCase
//        return decoder
//    }()
    
    
    
    func createNewUser(user: DBUser)async throws {
        try userDocument(userId: user.userId).setData(from: user, merge: false
//                                                      encoder:  encoder
        )
    }
    
//    func createNewUser(auth : AuthDataResultModel) async throws {
//        var userData : [String:Any] = [
//            "user_id": auth.uid,
//            "is_anonymous": auth.anonmous ,
//            "date_created": Timestamp()
//        ]
//        if let email = auth.email {
//            userData ["email"] = email
//            
//        }
//        if let photoUrl = auth.photoUrl{
//            userData["photo_url"] = photoUrl
//        }
//        try await userDocument(userId: auth.uid).setData(userData)
//       
//        
//    }
    
    func getUser(userID: String)async throws -> DBUser {
        try await userDocument(userId: userID).getDocument(as: DBUser.self
//                                                           decoder: decoder
        )
    }
    
//    func getUser (userId : String) async throws -> DBUser {
//        let snapshot = try await userDocument(userId: userId).getDocument()
//        
//        guard let data = snapshot.data(), let userId = data["user_id"] as? String else {
//            throw URLError(.badURL)
//        }
//        
//        let isAnonymous = data["is_anonymous"] as? Bool
//        let email = data["email"] as? String
//        let photoUrl = data["photo_url"] as? String
//        let date = data["date_created"] as?  Date
//        
//        return DBUser(userId: userId, isAnonymous: isAnonymous, email: email, photoUrl: photoUrl, dateCreated: date)
//        
//    }
    func updateUserPremiumStatus(user : DBUser)async throws {
        try userDocument(userId: user.userId).setData(from: user, merge: true)
    }
    func updatePremiumStatus(userId: String , isPremium  : Bool)async throws {
        let  data :[String : Any] = [
            DBUser.CodingKeys.isPremium.rawValue  : isPremium
        ]
        try  await userDocument(userId: userId).updateData(data)
    }
}
