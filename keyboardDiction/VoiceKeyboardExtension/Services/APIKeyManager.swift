//
//  APIKeyManager.swift
//  keyboardDiction
//
//  Created by Arpit Verma on 9/1/25.
//

import Foundation
import Security

// MARK: - API Key Manager Protocol
protocol APIKeyManagerProtocol {
    func getAPIKey() -> String?
    func setAPIKey(_ key: String) -> Bool
    func removeAPIKey() -> Bool
}

// MARK: - API Key Manager Implementation
class APIKeyManager: APIKeyManagerProtocol {
    
    // MARK: - Constants
    private let service = "com.keyboardDiction.groqAPI"
    private let account = "groqAPIKey"
    
    // MARK: - Get API Key
    func getAPIKey() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess,
              let data = result as? Data,
              let apiKey = String(data: data, encoding: .utf8) else {
            return nil
        }
        
        return apiKey
    }
    
    // MARK: - Set API Key
    func setAPIKey(_ key: String) -> Bool {
        guard let data = key.data(using: .utf8) else {
            return false
        }
        
        // First, try to update existing key
        let updateQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        
        let updateAttributes: [String: Any] = [
            kSecValueData as String: data
        ]
        
        let updateStatus = SecItemUpdate(updateQuery as CFDictionary, updateAttributes as CFDictionary)
        
        if updateStatus == errSecSuccess {
            return true
        }
        
        // If update failed, try to add new key
        if updateStatus == errSecItemNotFound {
            let addQuery: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: service,
                kSecAttrAccount as String: account,
                kSecValueData as String: data,
                kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
            ]
            
            let addStatus = SecItemAdd(addQuery as CFDictionary, nil)
            return addStatus == errSecSuccess
        }
        
        return false
    }
    
    // MARK: - Remove API Key
    func removeAPIKey() -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess || status == errSecItemNotFound
    }
}
