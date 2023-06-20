//
//  ContentModel.swift
//  Users
//
//  Created by Bohdan Zhyzhchenko on 19.06.2023.
//

import Foundation
import Combine

class ContentModel: ObservableObject {
    
    @Published var users = [User]()
    
    @Published var currentPage = 1
    
    init() {
        
        getUsersApi(currentPage: currentPage)
        
    }
    
    func loadMore() {
        
        getUsersApi(currentPage: currentPage)
        
    }
    
    // MARK: - API Methods
    // TODO: Check if function works
    func getUsersApi(currentPage: Int) {
        
        // Create URL
        var urlComponents = URLComponents(string: Constants.usersUrl)
        urlComponents?.queryItems = [
            URLQueryItem(name: "since", value: String(currentPage)),
            URLQueryItem(name: "per_page", value: String(Constants.paginantionStep))
        ]
        
        let url = urlComponents?.url
        
        // Create request
        if url == url {
            
            // Create request
            var request = URLRequest(url: url!)
            
            request.httpMethod = "GET"
            
            request.addValue("Bearer \(Constants.apiToken)", forHTTPHeaderField: "Authorization")
            
            // Get URL session
            let session = URLSession.shared
            
            // Create Data Task
            let dataTask = session.dataTask(with: url!) { data, response, error in
                
                if error == nil {
                    
                    do {
                        //Parse JSON
                        let result = try JSONDecoder().decode([User].self, from: data!)
                        print(result)
                        print(currentPage)
                        
                        DispatchQueue.main.async {
                            
                            for user in result {
                                // Check if user is not in users array
                                if !self.users.contains(where: { $0.id == user.id}) {
                                    self.users.append(user)
                                }
                                
                                //Call the getImage function for the users
                                user.getImageData()
                            }
                            
                            self.currentPage += Constants.paginantionStep
                        }
                    }
                    catch {
                        print(error)
                    }
                    
                }
                
            }
            
            // Start the Data Task
            dataTask.resume()
            
        }
        
    }
    
    // MARK: - SQLite methods
    func getUsersSQLite() {
        
    }
    
}
