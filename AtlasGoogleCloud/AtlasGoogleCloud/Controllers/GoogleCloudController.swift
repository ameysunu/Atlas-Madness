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
        let fileName = "\(name).json"
        let fileURL = folderURL.appendingPathComponent(fileName)

        do {
            try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)

            let newlineDelimitedJSON = jsonData.map { try! JSONEncoder().encode($0) }
                .map { String(data: $0, encoding: .utf8)! }
                .joined(separator: "\n")

            if FileManager.default.fileExists(atPath: fileURL.path) {
                // File already exists, so update its contents
                do {
                    let fileHandle = try FileHandle(forWritingTo: fileURL)
                    fileHandle.seekToEndOfFile()

                    // Clear the existing contents of the file
                    fileHandle.truncateFile(atOffset: 0)

                    if let newData = newlineDelimitedJSON.data(using: .utf8) {
                        // Write the new data to the file
                        fileHandle.write(newData)

                        // Close the file handle
                        fileHandle.closeFile()
                    }

                    print("Updated JSON file")
                } catch {
                    // Handle file write error
                    print("Failed to update JSON file: \(error)")
                }
            } else {
                // File doesn't exist, so create a new file
                do {
                    try newlineDelimitedJSON.write(to: fileURL, atomically: true, encoding: .utf8)

                    print("Created JSON file")
                } catch {
                    // Handle file write error
                    print("Failed to create JSON file: \(error)")
                }
            }

            let accessToken = Bundle.main.object(forInfoDictionaryKey: "OAUTH_KEY") as! String
            let bucketName = "ameyjson-data"
            let objectName = "\(name).json"

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
                print("Failed to read file data: \(error)")
            }
        } catch {
            // Handle file or directory creation error
            print("Failed to create directory: \(error)")
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

func sendQueryToDialogFlow(userText: String, completion: @escaping (String) -> Void){
   // let apiKey = Bundle.main.object(forInfoDictionaryKey: "OAUTH_KEY") as! String
    let apiKey = Bundle.main.object(forInfoDictionaryKey: "DIALOGFLOW_KEY") as! String
    let projectID = "myagent-bvsq"
    let sessionID = "9b2b5a5b-2778-75e6-ce3a-d05c2a420a09"
    let url = URL(string: "https://dialogflow.googleapis.com/v2/projects/\(projectID)/agent/sessions/\(sessionID):detectIntent")!
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
    request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
    
    let queryInput: [String: Any] = [
        "text": [
            "text": "\(userText)",
            "languageCode": "en"
        ]
    ]
    
    let queryParams: [String: Any] = [
        "source": "DIALOGFLOW_CONSOLE",
        "timeZone": "Europe/Dublin",
        "sentimentAnalysisRequestConfig": [
            "analyzeQueryTextSentiment": true
        ]
    ]
    
    let payload: [String: Any] = [
        "queryInput": queryInput,
        "queryParams": queryParams
    ]
    
    let jsonData = try? JSONSerialization.data(withJSONObject: payload)
    request.httpBody = jsonData
    
    let session = URLSession.shared
    let task = session.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Error: \(error)")
            return
        }
        
        if let jsonString = String(data: data!, encoding: .utf8) {
            print("Response: \(jsonString)")
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(DialogflowResponse.self, from: data!)
                
                let fulfillmentText = response.queryResult.fulfillmentMessages.first?.text.text.first
                completion(fulfillmentText ?? "")
                print("Fulfillment Text: \(fulfillmentText ?? "")")
            } catch {
                print("Error decoding JSON response: \(error)")
                completion("Error decoding JSON response: \(error)")
            }
        }
    }
    
    task.resume()
}

/*
 
 curl -H "Content-Type: application/json; charset=utf-8"  -H "Authorization: Bearer ya29.a0AWY7CkkU21v9czpT767MTEilOW3HziiG-9tDAPizZFuNTlOHYnsIVGTf9yk_Nd4nxDUqC5EbIZRYxLpOUFpokb2UYTLwD6qPSFRlFT8-LQUUinNMv10R-XBrQ0moFv6dde4_VBojlKaoyCO3LqhAoaU5ih1TbP1HZ2Ub7ZMRfwF_R56KEGwg0BOk1HJp7O5K4lllioZTPI4xr7EFmxEfFSMBPt4AbMr1jzj8K1YnVqDHOvY2mUqwAP28sSQZJ1j1V-sMdBNRQ6iPAakdZQNLggPKXzUU0kmgBhHVBaCholPExaMWN6LhvKuvbFsyAvqCFMrI6sBN8G2LsQDsgPfgU2-zEXF_7aySK4sS2WlMGWfkee1u9iSpjIfnU6tf-oskzec5SeRixsvPgWwVmEToNs4WvcqBE681aCgYKAXoSARASFQG1tDrpEyzx0H8BSu-fFb3Pde0rYg0423"  -d "{\"queryInput\":{\"text\":{\"text\":\"mindful techniques\",\"languageCode\":\"en\"}},\"queryParams\":{\"source\":\"DIALOGFLOW_CONSOLE\",\"timeZone\":\"Europe/Dublin\",\"sentimentAnalysisRequestConfig\":{\"analyzeQueryTextSentiment\":true}}}" "https://dialogflow.googleapis.com/v2/projects/myagent-bvsq/agent/sessions/9b2b5a5b-2778-75e6-ce3a-d05c2a420a09:detectIntent"
 */
