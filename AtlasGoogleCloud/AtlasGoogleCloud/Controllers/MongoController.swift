//
//  MongoController.swift
//  AtlasGoogleCloud
//
//  Created by Amey Sunu on 22/06/2023.
//

import Foundation

func addUserToMongo(userid: String, password: String, completion: @escaping (String) -> Void) {
    guard let url = URL(string: "https://eu-west-1.aws.data.mongodb-api.com/app/data-wnfuh/endpoint/data/v1/action/insertOne") else {
        print("Invalid URL")
        return
    }
    
    let parameters = [
        "collection": "user",
        "database": "users",
        "dataSource": "MyCluster",
        "document": ["id": "\(userid)", "password": "\(password)"]
    ] as [String : Any]
    
    let apiKey = Bundle.main.object(forInfoDictionaryKey: "MONGO_API_KEY") as! String
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("*", forHTTPHeaderField: "Access-Control-Request-Headers")
    request.setValue(apiKey, forHTTPHeaderField: "api-key")
    
    
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
        request.httpBody = jsonData
    } catch {
        print("Failed to serialize JSON: \(error)")
        return
    }
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let error = error {
            completion("Request error: \(error)")
            return
        }
        
        if let data = data {
            if let json = try? JSONSerialization.jsonObject(with: data, options: []),
               let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
               let jsonString = String(data: jsonData, encoding: .utf8) {
                completion("Response: \(jsonString)")
            }
        }
    }
    
    task.resume()
}


func checkIfUserExists(userid: String, completion: @escaping (String) -> Void) {
    guard let url = URL(string: "https://eu-west-1.aws.data.mongodb-api.com/app/data-wnfuh/endpoint/data/v1/action/findOne") else {
        print("Invalid URL")
        completion("Invalid URL")
        return
    }
    
    let parameters = [
        "collection": "user",
        "database": "users",
        "dataSource": "MyCluster",
        "filter": ["id": userid]
    ] as [String: Any]
    
    let apiKey = Bundle.main.object(forInfoDictionaryKey: "MONGO_API_KEY") as! String
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("*", forHTTPHeaderField: "Access-Control-Request-Headers")
    request.setValue(apiKey, forHTTPHeaderField: "api-key")
    
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
        request.httpBody = jsonData
    } catch {
        print("Failed to serialize JSON: \(error)")
        completion("Failed to serialize JSON: \(error)")
        return
    }
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let error = error {
            print("Request error: \(error)")
            completion("Request error: \(error)")
            return
        }
        
        if let data = data {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let jsonDict = json as? [String: Any] {
                    if let document = jsonDict["document"] {
                        if let documentDict = document as? [String: Any], let id = documentDict["id"] as? String {
                            completion(id)
                        } else {
                            completion("Doesn't exist")
                        }
                    } else {
                        completion("Document field not found in the response")
                    }
                } else {
                    completion("Invalid JSON response")
                }
            } catch {
                completion("JSON deserialization error: \(error)")
            }
        }
    }
    
    task.resume()
}


func getUserPassword(userid: String, completion: @escaping (String) -> Void) {
    guard let url = URL(string: "https://eu-west-1.aws.data.mongodb-api.com/app/data-wnfuh/endpoint/data/v1/action/findOne") else {
        print("Invalid URL")
        completion("Invalid URL")
        return
    }
    
    let parameters = [
        "collection": "user",
        "database": "users",
        "dataSource": "MyCluster",
        "filter": ["id": userid]
    ] as [String: Any]
    
    let apiKey = Bundle.main.object(forInfoDictionaryKey: "MONGO_API_KEY") as! String
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("*", forHTTPHeaderField: "Access-Control-Request-Headers")
    request.setValue(apiKey, forHTTPHeaderField: "api-key")
    
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
        request.httpBody = jsonData
    } catch {
        print("Failed to serialize JSON: \(error)")
        completion("Failed to serialize JSON: \(error)")
        return
    }
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let error = error {
            print("Request error: \(error)")
            completion("Request error: \(error)")
            return
        }
        
        if let data = data {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let jsonDict = json as? [String: Any] {
                    if let document = jsonDict["document"] {
                        if let documentDict = document as? [String: Any], let id = documentDict["password"] as? String {
                            completion(id)
                        } else {
                            completion("Doesn't exist")
                        }
                    } else {
                        completion("Document field not found in the response")
                    }
                } else {
                    completion("Invalid JSON response")
                }
            } catch {
                completion("JSON deserialization error: \(error)")
            }
        }
    }
    
    task.resume()
}