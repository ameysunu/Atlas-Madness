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

func addUserPreferences(userid: String, age: String, gender: String, topics: Set<String>, goals:[String], preferences: Bool,  completion: @escaping (String) -> Void) {
    guard let url = URL(string: "https://eu-west-1.aws.data.mongodb-api.com/app/data-wnfuh/endpoint/data/v1/action/updateOne") else {
        print("Invalid URL")
        return
    }
    
    let parameters = [
        "collection": "user",
        "database": "users",
        "dataSource": "MyCluster",
        "filter": ["id": "\(userid)"],
        "update": [
            "$set": ["age": "\(age)", "name": "\(userid)", "gender": "\(gender)", "topics": "\(topics)", "goals": "\(goals)", "preferences": "\(preferences)"]
        ]
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

func getUserPreferences(userid: String, completion: @escaping (String) -> Void){
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
                        if let documentDict = document as? [String: Any], let preferences = documentDict["preferences"] as? String {
                            completion(preferences)
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
    
    task.resume()}

func addMoodData(userid: String, mood: String, rating: Double, notes: String, context: String, trigger: String, sleepQuality: Double, appetite: Double, energyLevel: Double, timeStamp: String, completion: @escaping (String) -> Void) {
    guard let url = URL(string: "https://eu-west-1.aws.data.mongodb-api.com/app/data-wnfuh/endpoint/data/v1/action/insertOne") else {
        print("Invalid URL")
        return
    }
    
    let parameters = [
        "collection": "moods",
        "database": "users",
        "dataSource": "MyCluster",
        "document": ["id": "\(userid)", "mood": "\(mood)", "rating": "\(rating)", "notes": "\(notes)", "context": "\(context)", "trigger": "\(trigger)", "sleepQuality": "\(sleepQuality)", "appetite": "\(appetite)", "energyLevel": "\(energyLevel)", "timestamp": "\(timeStamp)"]
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

func getCurrentUserMoods(userid: String, completion: @escaping ([Mood]?, Error?) -> Void) {
    guard let url = URL(string: "https://eu-west-1.aws.data.mongodb-api.com/app/data-wnfuh/endpoint/data/v1/action/find") else {
        print("Invalid URL")
        completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
        return
    }
    
    let parameters = [
        "collection": "moods",
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
        completion(nil, error)
        return
    }
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let error = error {
            print("Request error: \(error)")
            completion(nil, error)
            return
        }
        
        if let data = data {
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(ResponseWrapper<Mood>.self, from: data)
                let moods = result.documents
                completion(moods, nil)
            } catch {
                print("JSON decoding error: \(error)")
                completion(nil, error)
            }
        }
    }
    
    task.resume()
}

struct ResponseWrapper<T: Codable>: Codable {
    let documents: [T]
}
