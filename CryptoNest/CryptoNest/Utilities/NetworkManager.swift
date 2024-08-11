//
//  NetworkManager.swift
//  CryptoNest
//
//  Created by arpit verma on 09/08/24.
//

import Foundation
import Combine

class NetworkingManager{
    enum NetworkingError:LocalizedError {
        case badURLResponse(url:URL)
        case unkown
        var errorDescription: String? {
            switch self {	
            case .badURLResponse(url: let url):
                return "[🔥] Bad URL Response: \(url)"
            case .unkown:
                return "[⚠️] Unknown Error"
            }
            
        }
    }
    static func download(url:URL)->AnyPublisher <Data,Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap({try  handleURLResponse(output: $0, url : url)})
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
        static func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url : URL) throws -> Data {
        guard let response = output.response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode < 300 else {
            throw NetworkingError.badURLResponse(url:url)
        }
        return output.data
    }
    
static func handleCompletion(completion: Subscribers.Completion<Error>){
    switch completion {
    case .finished:
        break
    case .failure(let error):
        print("Error: \(error)")
    }
}
}


