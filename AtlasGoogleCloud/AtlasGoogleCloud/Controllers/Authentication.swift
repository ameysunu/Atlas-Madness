//
//  Authentication.swift
//  AtlasGoogleCloud
//
//  Created by Amey Sunu on 21/06/2023.
//

import Foundation

func loginUser(userId: String, password: String, completion: @escaping (String) -> Void){
    // check userid exists in atlas
    checkIfUserExists(userid: userId) { result in
        print(result);
        if(result == userId){
            // retrieve the password from mongodb
            getUserPassword(userid: userId){ pwd in
            // decrypt the mongodb password.
                decryptWithKMS(cipherText: pwd){ plainText in
                    if(password == plainText){
                        //log the user in
                        completion("log in")
                    } else {
                        completion("Incorrect Password")
                    }
                }
            }
        } else  {
            completion("User not found in the system")
        }
    }
}

func registerUser(userId: String, password: String, completion: @escaping (String) -> Void){
    //check userid exists in atlas
    checkIfUserExists(userid: userId) { user in
        if(user == "Doesn't exist"){
            //send the password to kms to encrypt
            encryptWithKMS(plainText: password) { encryptedPass in
                // get the encrypted password and push that to atlas along with the userid
                addUserToMongo(userid: userId, password: encryptedPass){ result in
                    completion(result)
                }
            }
            
        } else {
            completion("User exists already. Use the login page")
        }
    }
    
    
    
    
}

func encryptWithKMS(plainText: String, completion: @escaping (String) -> Void){
    // Set the request URL
    let url = URL(string: "https://cloudkms.googleapis.com/v1/projects/admin-beaker-290608/locations/europe-west2/keyRings/Test/cryptoKeys/users:encrypt")!
    let oauthkey = Bundle.main.object(forInfoDictionaryKey: "OAUTH_KEY") as! String

    // Create the request object
    var request = URLRequest(url: url)
    request.httpMethod = "POST"

    // Set the request headers
    request.setValue("Bearer \(oauthkey)", forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    // Set the request body data
    let jsonBody = [
        "plaintext": "\(plainText)" // Base64-encoded string
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
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let jsonDict = json as? [String: Any], let ciphertext = jsonDict["ciphertext"] as? String {
                    //print("Plaintext: \(plaintext)")
                    completion(ciphertext)
                } else {
                    completion("Ciphertext field not found in the response")
                }
            } catch {
                completion("JSON deserialization error: \(error)")
            }
        }
//        } else if let data = data {
//            let responseString = String(data: data, encoding: .utf8)
//            print("Response: \(responseString ?? "")")
//        }
    }
    task.resume()
    
    //CiQAo6zuXo2q2lPWLbeV7quV8sTMblh3TyvZsIpWXHPy6DlX1qcSLgAyvrvuxkdK1KbPW5VF2fsL1UtjsgHOoz9jyjavie5lRKfpga9pLAZD5jPGKjM
}

func decryptWithKMS(cipherText: String, completion: @escaping (String) -> Void){
    // Set the request URL
    let url = URL(string: "https://cloudkms.googleapis.com/v1/projects/admin-beaker-290608/locations/europe-west2/keyRings/Test/cryptoKeys/users:decrypt")!
    let oauthkey = Bundle.main.object(forInfoDictionaryKey: "OAUTH_KEY") as! String
    
    //print(connectToMongo())

    // Create the request object
    var request = URLRequest(url: url)
    request.httpMethod = "POST"

    // Set the request headers
    request.setValue("Bearer \(oauthkey)", forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    // Set the request body data
    let jsonBody = [
        "ciphertext": "\(cipherText)" // Base64-encoded string
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
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let jsonDict = json as? [String: Any], let plaintext = jsonDict["plaintext"] as? String {
                    //print("Plaintext: \(plaintext)")
                    completion(plaintext)
                } else {
                    completion("Plaintext field not found in the response")
                }
            } catch {
                completion("JSON deserialization error: \(error)")
            }
        }
        
    }
    task.resume()
}
