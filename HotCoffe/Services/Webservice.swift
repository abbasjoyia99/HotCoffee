//
//  Webservice.swift
//  HotCoffe
//
//  Created by Developer on 28/07/2022.
//

import Foundation

enum NetworkError:Error {
    case decodingError
    case domainError
    case urlError
}
enum HttpMethod:String {
    case get = "GET"
    case post = "POST"
}
struct Resource<T:Codable> {
    let url:URL
    var httpMethod:HttpMethod = .get
    var boday:Data? = nil
}

extension Resource {
    init?(_ url:URL) {
        self.url = url
    }
}
class Webservice {
    func load<T>(resource:Resource<T>, completion:@escaping (Result<T, NetworkError>)-> Void) {
        
        var request = URLRequest(url: resource.url)
        request.httpMethod = resource.httpMethod.rawValue
        request.httpBody  = resource.boday
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data,response ,error in
            
            guard let data = data, error == nil else {
                completion(.failure(.domainError))
                return
            }
            let result = try? JSONDecoder().decode(T.self,from:data)
            if let result = result {
                DispatchQueue.main.async {
                    completion(.success(result))
                }
            } else {
                completion(.failure(.decodingError))
            }
            
        }.resume()
    }
}
