//
//  Authentication.swift
//  AtlasGoogleCloud
//
//  Created by Amey Sunu on 21/06/2023.
//

import Foundation

func encryptWithKMS(data: String, completion: @escaping (Result<String, Error>) -> Void) {
    let keyName = "projects/admin-beaker-290608/locations/global/keyRings/Test/cryptoKeys/users"
    let url = URL(string: "https://cloudkms.googleapis.com/v1/" + keyName + ":encrypt")!
    let apiKey = ""  // Replace with your API key or use authorization headers
    
    let parameters: [String: Any] = [
        "plaintext": data.data(using: .utf8)?.base64EncodedString()
    ]
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }
        
        if let data = data,
           let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
           let ciphertext = responseJSON["ciphertext"] as? String {
            completion(.success(ciphertext))
        } else {
            completion(.failure(NSError(domain: "EncryptionError", code: 0, userInfo: nil)))
        }
    }
    task.resume()
}

func decryptWithKMS(data: String, completion: @escaping (Result<String, Error>) -> Void) {
    let keyName = "projects/admin-beaker-290608/locations/global/keyRings/Test/cryptoKeys/users"
    let url = URL(string: "https://cloudkms.googleapis.com/v1/" + keyName + ":decrypt")!
    let apiKey = "" // Replace with your API key or use authorization headers
    
    let parameters: [String: Any] = [
        "ciphertext": data
    ]
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }
        
        if let data = data,
           let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
           let plaintextData = responseJSON["plaintext"] as? String,
           let plaintext = Data(base64Encoded: plaintextData).flatMap({ String(data: $0, encoding: .utf8) }) {
            completion(.success(plaintext))
        } else {
            completion(.failure(NSError(domain: "DecryptionError", code: 0, userInfo: nil)))
        }
    }
    task.resume()
}


// Example usage
//encryptWithKMS(data: "Hello, World!") { result in
//    switch result {
//    case .success(let ciphertext):
//        print("Ciphertext: \(ciphertext)")
//
//        decryptWithKMS(data: ciphertext) { result in
//            switch result {
//            case .success(let plaintext):
//


func testExec(){
    // Set the request URL
    let url = URL(string: "https://cloudkms.googleapis.com/v1/projects/admin-beaker-290608/locations/europe-west2/keyRings/Test/cryptoKeys/users:encrypt")!

    // Create the request object
    var request = URLRequest(url: url)
    request.httpMethod = "POST"

    // Set the request headers
    request.setValue("Bearer ya2..", forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    // Set the request body data
    let jsonBody = [
        "plaintext": "testData" // Base64-encoded string
    ]
    let jsonData = try? JSONSerialization.data(withJSONObject: jsonBody)
    request.httpBody = jsonData

    // Create a URLSession and perform the request
    let session = URLSession.shared
    let task = session.dataTask(with: request) { (data, response, error) in
        // Handle the response and error
        if let error = error {
            print("Error: \(error)")
        } else if let data = data {
            let responseString = String(data: data, encoding: .utf8)
            print("Response: \(responseString ?? "")")
        }
    }
    task.resume()
    
    //CiQAo6zuXo2q2lPWLbeV7quV8sTMblh3TyvZsIpWXHPy6DlX1qcSLgAyvrvuxkdK1KbPW5VF2fsL1UtjsgHOoz9jyjavie5lRKfpga9pLAZD5jPGKjM
}

func textEXXec(){
    // Set the request URL
    let url = URL(string: "https://cloudkms.googleapis.com/v1/projects/admin-beaker-290608/locations/europe-west2/keyRings/Test/cryptoKeys/users:decrypt")!

    // Create the request object
    var request = URLRequest(url: url)
    request.httpMethod = "POST"

    // Set the request headers
    request.setValue("Bearer ya2..", forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    // Set the request body data
    let jsonBody = [
        "ciphertext": "CiQAo6zuXo2q2lPWLbeV7quV8sTMblh3TyvZsIpWXHPy6DlX1qcSLgAyvrvuxkdK1KbPW5VF2fsL1UtjsgHOoz9jyjavie5lRKfpga9pLAZD5jPGKjM" // Base64-encoded string
    ]
    let jsonData = try? JSONSerialization.data(withJSONObject: jsonBody)
    request.httpBody = jsonData

    // Create a URLSession and perform the request
    let session = URLSession.shared
    let task = session.dataTask(with: request) { (data, response, error) in
        // Handle the response and error
        if let error = error {
            print("Error: \(error)")
        } else if let data = data {
            let responseString = String(data: data, encoding: .utf8)
            print("Response: \(responseString ?? "")")
        }
    }
    task.resume()
}
