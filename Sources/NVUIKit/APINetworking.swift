//
//  APINetworking.swift
//  HealthcareIP
//
//  Created by Navneet.verma on 4/1/22.
//

import Foundation
import UIKit

class APINetworking {
    static let shared = APINetworking()
    
    public enum APIError {
        case requestIncomplete(error: Error)
        case noData
    }
    
    public enum APIResult<T> {
        case success(T)
        case failure(APIError)
    }
    
    let defaultSession = URLSession(configuration: .default)
    typealias SerializationFunction<T> = (Data?, URLResponse?, Error?) -> APIResult<T>
    
    @discardableResult
    func request<T: Decodable>(_ url: URL, completion: @escaping (APIResult<T>) -> Void) -> URLSessionDataTask {
        return request(url, serializationFunction: serializeJSON, completion: completion)
    }
    
    @discardableResult
    private func request<T>(_ url: URL, serializationFunction: @escaping SerializationFunction<T>,
                            completion: @escaping (APIResult<T>) -> Void) -> URLSessionDataTask {
        let dataTask = defaultSession.dataTask(with: url) { data, response, error in
            let result: APIResult<T> = serializationFunction(data, response, error)
            DispatchQueue.main.async {
                completion(result)
            }
        }
        dataTask.resume()
        return dataTask
    }
    
    private func serializeJSON<T: Decodable>(with data: Data?, response: URLResponse?, error: Error?) -> APIResult<T> {
        if let error = error { return .failure(.requestIncomplete(error: error)) }
        guard let data = data else { return .failure(.noData) }
        do {
            let serializedValue = try JSONDecoder().decode(T.self, from: data)
            return .success(serializedValue)
        } catch let error {
            return .failure(.requestIncomplete(error: error))
        }
    }
    
    @discardableResult
    func requestImage(withURL url: URL, completion: @escaping (APIResult<UIImage>) -> Void) -> URLSessionDataTask {
        return request(url, serializationFunction: serializeImage, completion: completion)
    }

    private func serializeImage(with data: Data?, response: URLResponse?, error: Error?) -> APIResult<UIImage> {
        if let error = error { return .failure(.requestIncomplete(error: error)) }
        guard let data = data, let image = UIImage(data: data) else { return .failure(APIError.noData) }
        return .success(image)
    }

}
