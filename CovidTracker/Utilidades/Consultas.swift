//
//  Consults.swift
//  CovidTracker
//
//  Created by Andres Herrera on 1/31/21.
//

import Foundation

struct parsingError: Error {}

final class Consulta<A>: ObservableObject {
    
    @Published var result: Result<A, Error>? = nil
    
    var value: A? {
        try? result?.get()
    }
    
    var token: Token?
    let url: URL
   // let parameters: [String : Any]
    let transform: (Data) -> A?
    
    init(url: URL ,transform: @escaping (Data) -> A?) {
        self.url = url
        self.transform = transform
    }
    
    func consulta(parametros: [String : Any]) {
        
        let postData = try? JSONSerialization.data(withJSONObject: parametros, options: [])
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = postData! as Data
        
        URLSession.shared.dataTask(with: request) {(data, response, error ) in
            DispatchQueue.main.async {
                if let data = data, let value = self.transform(data) {
                    self.result = .success(value)
                } else {
                    self.result = .failure(parsingError())
                }
            }
        }.resume()
    }
    func postConToken(token: String, parametros: [String : Any], completion: @escaping (Result<A, Error>) -> Void ) {
        
        let postData = try? JSONSerialization.data(withJSONObject: parametros, options: [])
        
        let headers = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData! as Data
        
        URLSession.shared.dataTask(with: request) {(data, response, error ) in
            DispatchQueue.main.async {
                if let data = data, let value = self.transform(data) {
                    self.result = .success(value)
                    completion(.success(value))
                } else {
                    self.result = .failure(parsingError())
                    completion(.failure(parsingError()))
                }
            }
        }.resume()
    }
    
    func getConToken(token: String, completion: @escaping (Result<A, Error>) -> Void) {
        
       // let postData = try? JSONSerialization.data(withJSONObject: parametros, options: [])
        
        let headers = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
       // request.httpBody = postData! as Data
        
        URLSession.shared.dataTask(with: request) {(data, response, error ) in
            DispatchQueue.main.async {
                if let data = data, let value = self.transform(data) {
                    self.result = .success(value)
                    completion(.success(value))
                    
                } else {
                    self.result = .failure(parsingError())
                    completion(.failure(parsingError()))
                }
            }
        }.resume()
    }
    
    func putConToken(token: String, parametros: [String : Any], completion: @escaping (Result<A, Error>) -> Void ) {
        
        let postData = try? JSONSerialization.data(withJSONObject: parametros, options: [])
        
        let headers = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData! as Data
        
        URLSession.shared.dataTask(with: request) {(data, response, error ) in
            DispatchQueue.main.async {
                if let data = data, let value = self.transform(data) {
                    self.result = .success(value)
                    completion(.success(value))
                } else {
                    self.result = .failure(parsingError())
                    completion(.failure(parsingError()))
                }
            }
        }.resume()
    }
    
    func postSinToken(parametros: [String : Any], completion: @escaping (Result<A, Error>) -> Void ) {
        
        let postData = try? JSONSerialization.data(withJSONObject: parametros, options: [])
        
        let headers = [
            "Content-Type": "application/json"
        ]
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData! as Data
        
        URLSession.shared.dataTask(with: request) {(data, response, error ) in
            DispatchQueue.main.async {
                if let data = data, let value = self.transform(data) {
                    self.result = .success(value)
                    completion(.success(value))
                } else {
                    self.result = .failure(parsingError())
                    completion(.failure(parsingError()))
                }
            }
        }.resume()
    }
    
    static func autenticar(username: String, password: String, completion: @escaping (Result<Token, Error>) -> Void) {
        
        let basicCred = "\(username):\(password)".data(using: .utf8)!.base64EncodedString()
        
        print(basicCred)
        
        let headers = [
            "Authorization": "Basic \(basicCred)",
            "Content-Type": "application/json"
        ]
        
        guard let url = URL(string: "http://127.0.0.1:8080/usuarios/autenticar") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data, error == nil else {
                completion(.failure(parsingError()))
                return
            }
    
            let result = try? JSONDecoder().decode(Token.self, from: data)
            if let result = result {
                DispatchQueue.main.async { 
               //     self.token = result
                    completion(.success(result))
                }
            } else {
                DispatchQueue.main.async {
                    completion(.failure(parsingError()))
                }
            }
        }.resume()
    }
}
