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

