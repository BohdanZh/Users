//
//  ContentModel.swift
//  Users
//
//  Created by Bohdan Zhyzhchenko on 19.06.2023.
//

import Foundation

class ContentModel: ObservableObject {
    
    @Published var users = [User]()
    
    @Published var currentPage = 0
    
    init() {
        
        getUsersApi(currentPage: currentPage)
        
    }
    
    func loadMoreUsers() {
        
        getUsersApi(currentPage: currentPage)
        
    }
    
    // MARK: - API Methods
    // TODO: Check if function works
    func getUsersApi(currentPage: Int) {
        
        // Create URL
        var urlComponents = URLComponents(string: Constants.usersUrl)
        urlComponents?.queryItems = [
            URLQueryItem(name: "since", value: String(currentPage)),
            URLQueryItem(name: "per_page", value: String(Constants.userPaginantionStep))
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
            let dataTask = session.dataTask(with: request) { data, response, error in
                
                if error == nil {
                    
                    do {
                        //Parse JSON
                        let result = try JSONDecoder().decode([User].self, from: data!)
                        
                        DispatchQueue.main.async {
                            
                            for user in result {
                                // Check if user is not in users array
                                if !self.users.contains(where: { $0.id == user.id}) {
                                    self.users.append(user)
                                }
                                
                                //Call the getImage function for the users
                                user.getImageData()
                            }
                            
                            self.currentPage += Constants.userPaginantionStep
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
    
    func getReposAPI(currentPage: Int, reposUrl: String?, id: Int?) {
        
        guard reposUrl != nil && id != nil else {
            return
        }
        
        // Create URL
        var urlComponents = URLComponents(string: reposUrl!)
        urlComponents?.queryItems = [
            URLQueryItem(name: "page", value: String(currentPage)),
            URLQueryItem(name: "per_page", value: String(Constants.repoPaginationStep))
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
            let dataTask = session.dataTask(with: request) { data, response, error in
                
                if error == nil {
                    
                    do {
                        // Parse JSON
                        let result = try JSONDecoder().decode([Repo].self, from: data!)
                        
                        DispatchQueue.main.async {
                            
                            // Find the user by the id
                            for user in self.users {
                                if user.id == id {
                                    
                                    if result.isEmpty {
                                        user.isReposFull = true
                                    }
                                    
                                    for repo in result {
                                        // Check if repo doesn't exist yet
                                        if !user.repos.contains(where: { $0.id == repo.id}) {
                                            // Add new repo
                                            user.repos.append(repo)
                                        }
                                        
                                        // TODO: Add repos to SQLite
                                    }
                                    
                                    user.currenPage += Constants.repoPaginationStep
                                    
                                }
                            }
                        }
                        
                    }
                    catch {
                        print(error)
                    }
                    
                }
            }
            dataTask.resume()
        }
        
    }
    
    // MARK: - SQLite methods
    func getUsersSQLite() {
        
    }
    
}
