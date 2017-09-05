//
//  PostsService.swift
//  ImageEditor
//
//  Created by Sergiy Sobol on 31.08.17.
//  Copyright © 2017 Sergiy Sobol. All rights reserved.
//

import UIKit
import Foundation

class PostsService {
    func createPost(imageUrl: String, name: String) {
        let dict = ["imageUrl": imageUrl, "content":name, "contentType":1] as [String : Any]
        makeHTTPPostRequest(path: "https://memassearch.herokuapp.com/posts", body: dict as [String : AnyObject])
    }
    
    func getAllPosts(callback: @escaping ([ImageModel]) -> Void) {
        makeHTTPGetRequest(path: "https://memassearch.herokuapp.com/posts", callback: callback)
    }
    

    private func makeHTTPPostRequest(path: String, body: [String: AnyObject]) {
        var request = URLRequest(url: URL(string: path)!)
        
        // Set the method to POST
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        do {
            // Set the POST body for the request
            let jsonBody = try JSONSerialization.data(withJSONObject: body, options: [])
            request.httpBody = jsonBody
            let session = URLSession.shared
            
            let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
                print(response)
            })
            

            task.resume()
        } catch {
            // Create your personal error
            //onCompletion(nil, nil)
        }
    }
    
    private func makeHTTPGetRequest(path: String, callback: @escaping ([ImageModel]) -> Void) {
        var request = URLRequest(url: URL(string: path)!)
        
        // Set the method to POST
        request.httpMethod = "GET"
        do {
            // Set the POST body for the request
            let session = URLSession.shared
            
            let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
                print(response)
                if let json = data {
                    let posts = self.parseJsonData(data: json)
                    print(posts)
                    callback(posts)
                }
            })
            
            
            task.resume()
        } catch {
            // Create your personal error
            //onCompletion(nil, nil)
        }
    }
    
    func parseJsonData(data: Data) -> [ImageModel] {
        var loans = [ImageModel]()
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: data, options:
                JSONSerialization.ReadingOptions.mutableContainers) as? NSArray
            // Parse JSON data
            let jsonPosts = jsonResult! as [AnyObject]
            for jsonLoan in jsonPosts {
                let loan = ImageModel(name: jsonLoan["content"] as! String, imageName:  jsonLoan["imageUrl"] as! String)

                loans.append(loan)
            }
        } catch {
            print(error)
        }
        return loans

    }
}
