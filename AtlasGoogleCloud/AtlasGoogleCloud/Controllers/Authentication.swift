//
//  Authentication.swift
//  AtlasGoogleCloud
//
//  Created by Amey Sunu on 21/06/2023.
//

import Foundation

func encryptWithKMS(){
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

func decryptWithKMS(){
    // Set the request URL
    let url = URL(string: "https://cloudkms.googleapis.com/v1/projects/admin-beaker-290608/locations/europe-west2/keyRings/Test/cryptoKeys/users:decrypt")!
    print(Bundle.main.object(forInfoDictionaryKey: "OAUTH_KEY") as! String)

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
