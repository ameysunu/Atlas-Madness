//
//  GoogleCloudController.swift
//  AtlasGoogleCloud
//
//  Created by Amey Sunu on 25/06/2023.
//

import Foundation

func exportDataToCloudStorage(jsonData: [Mood]) {
    var currentUserId = getLoginToken()

    if let userId = currentUserId {
        let name = userId.replacingOccurrences(of: "Optional(\"", with: "").replacingOccurrences(of: "\")", with: "")

        func getCurrentTimeStamp() -> String {
            let currentDateTime = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let dateString = dateFormatter.string(from: currentDateTime)

            return dateString
        }

        guard let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            // Handle document directory URL error
            return
        }

        let folderURL = documentDirectoryURL.appendingPathComponent(name)

        do {
            try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)

            let fileURL = folderURL.appendingPathComponent("\(getCurrentTimeStamp()).json")

            let newlineDelimitedJSON = jsonData.map { try! JSONEncoder().encode($0) }
                .map { String(data: $0, encoding: .utf8)! }
                .joined(separator: "\n")

            try newlineDelimitedJSON.write(to: fileURL, atomically: true, encoding: .utf8)

            let accessToken = Bundle.main.object(forInfoDictionaryKey: "OAUTH_KEY") as! String
            let bucketName = "ameyjson-data"
            let objectName = "\(name)-\(getCurrentTimeStamp()).json"

            let uploadURLString = "https://www.googleapis.com/upload/storage/v1/b/\(bucketName)/o?uploadType=media&name=\(objectName)"

            guard let uploadURL = URL(string: uploadURLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {
                // Handle URL creation error
                return
            }

            var request = URLRequest(url: uploadURL)
            request.httpMethod = "POST"
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            do {
                let fileData = try Data(contentsOf: fileURL)
                request.httpBody = fileData

                URLSession.shared.dataTask(with: request) { data, response, error in
                    // Handle the response or error here
                    print("Uploaded JSON")
                }.resume()
            } catch {
                // Handle file read error
            }
        } catch {
            // Handle file or directory creation error
        }
    } else {
        print("Name is nil")
    }
}

func getAverageEnergySleep(completion: @escaping (Double, Double, Double) -> Void) {
    
    let projectID = "admin-beaker-290608"
    let datasetID = "userdataset"
    let tableID = "MyTable"
    
    guard let url = URL(string: "https://bigquery.googleapis.com/bigquery/v2/projects/\(projectID)/queries") else {
        print("Invalid URL")
        return
    }
    
    let accessToken = Bundle.main.object(forInfoDictionaryKey: "OAUTH_KEY") as! String
    
    // Create the query string to calculate the average rating and energy level
    let query = """
    #standardSQL
    SELECT AVG(rating) AS average_rating, AVG(energyLevel) AS average_energy_level, AVG(sleepQuality) AS avg_sleep
    FROM `\(projectID).\(datasetID).\(tableID)`
    """
    
    // Create the request body with the query
    let body = ["query": query]
    let jsonData = try? JSONSerialization.data(withJSONObject: body)
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    request.httpBody = jsonData
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Error: \(error)")
            return
        }
        
        if let data = data {
            do {
                // Parse the JSON response
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let dict = json as? [String: Any],
                   let rows = dict["rows"] as? [[String: Any]],
                   let values = rows.first?["f"] as? [[String: Any]] {
                    if let values = values as? [[String: Any]], values.count >= 2 {
                        if let averageRating = values[0]["v"],
                           let averageEnergy = values[1]["v"],
                           let averageSleep = values[2]["v"]{
                            if let ratingString = averageRating as? String, // Runs here ...
                               let avgRating = Double(ratingString) {
                                if let energyString = averageEnergy as? String,
                                   let avgEnergy = Double(energyString) {
                                    if let sleepString = averageSleep as? String,
                                       let avgSleep = Double(sleepString){
                                        completion(avgRating, avgEnergy, avgSleep)
                                    }
                                } else {
                                    print("averageEnergy cannot be converted to Double")
                                }
                            } else {
                                print("averageRating cannot be converted to Double")
                            }
                        } else {
                            print("Invalid format of averageRating or averageEnergy")
                        }
                        
                        
                    }
                    
                    
                }
            } catch {
                print("Error parsing JSON: \(error)")
            }
        }
    }
    
    task.resume()
}

func getAverageMood(completion: @escaping (String) -> Void) {
    
    let projectID = "admin-beaker-290608"
    let datasetID = "userdataset"
    let tableID = "MyTable"
    
    guard let url = URL(string: "https://bigquery.googleapis.com/bigquery/v2/projects/\(projectID)/queries") else {
        print("Invalid URL")
        return
    }
    
    let accessToken = Bundle.main.object(forInfoDictionaryKey: "OAUTH_KEY") as! String
    
    // Create the query string to calculate the average rating and energy level
    let query = """
    #standardSQL
    SELECT mood FROM `\(projectID).\(datasetID).\(tableID)` GROUP BY mood ORDER BY COUNT(*) DESC LIMIT 1
    """
    
    // Create the request body with the query
    let body = ["query": query]
    let jsonData = try? JSONSerialization.data(withJSONObject: body)
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    request.httpBody = jsonData
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Error: \(error)")
            return
        }
        
        if let data = data {
            do {
                // Parse the JSON response
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                      let rows = json["rows"] as? [[String: Any]],
                      let values = rows.first?["f"] as? [[String: Any]],
                      let generalMood = values.first?["v"] as? String
                else {
                    completion("")
                    return
                }
                completion(generalMood)

            } catch {
                print("Error parsing JSON: \(error)")
            }
        }
    }
    
    task.resume()
}


func getTriggerContext(completion: @escaping (String) -> Void) {
    
    let projectID = "admin-beaker-290608"
    let datasetID = "userdataset"
    let tableID = "MyTable"
    
    guard let url = URL(string: "https://bigquery.googleapis.com/bigquery/v2/projects/\(projectID)/queries") else {
        print("Invalid URL")
        return
    }
    
    let accessToken = Bundle.main.object(forInfoDictionaryKey: "OAUTH_KEY") as! String
    
    // Create the query string to calculate the average rating and energy level
    let query = """
    #standardSQL
    SELECT trigger, COUNT(*) AS count FROM `\(projectID).\(datasetID).\(tableID)` GROUP BY trigger ORDER BY count DESC LIMIT 1;
    """
    
    // Create the request body with the query
    let body = ["query": query]
    let jsonData = try? JSONSerialization.data(withJSONObject: body)
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    request.httpBody = jsonData
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Error: \(error)")
            return
        }
        
        if let data = data {
            do {
                // Parse the JSON response
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                      let rows = json["rows"] as? [[String: Any]],
                      let values = rows.first?["f"] as? [[String: Any]],
                      let trigger = values.first?["v"] as? String
                else {
                    completion("")
                    return
                }
                completion(trigger)
                
            } catch {
                print("Error parsing JSON: \(error)")
            }
        }
    }
    
    task.resume()
}
