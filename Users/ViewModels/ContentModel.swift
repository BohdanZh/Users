//
//  ContentModel.swift
//  Users
//
//  Created by Bohdan Zhyzhchenko on 19.06.2023.
//

import Foundation
import SQLite

class ContentModel: ObservableObject {
    
    @Published var users = [User]()
    
    @Published var currentPage = 0
    
    @Published var isUsersFull = false
    
    // Create SQLite cache database
    let db = try? Connection()
    
    init() {
        
        setDatabase()
        
        getUsersSQLite()
        
        getUsersApi(currentPage: currentPage)
        
    }
    
    // MARK: - API Methods
    
    func getUsersApi(currentPage: Int) {
        
        // Create URL
        var urlComponents = URLComponents(string: Constants.API.usersUrl)
        urlComponents?.queryItems = [
            URLQueryItem(name: "since", value: String(currentPage)),
            URLQueryItem(name: "per_page", value: String(Constants.API.userPaginantionStep))
        ]
        
        let url = urlComponents?.url
        
        // Create request
        if url == url {
            
            // Get URL session
            let session = URLSession.shared
            
            // Check if possible to use GitHub REST API (I added here this if statment because REST API let more requests)
            if Constants.API.apiToken != "" {
                
                // Create request
                var request = URLRequest(url: url!, timeoutInterval: 4.0)
                
                request.httpMethod = "GET"
                
                request.addValue("Bearer \(Constants.API.apiToken)", forHTTPHeaderField: "Authorization")
                
                // Create Data Task
                let dataTask = session.dataTask(with: request) { data, response, error in
                    
                    self.userDataTask(data: data, responce: response, error: error)
                    
                }
                
                // Start the Data Task
                dataTask.resume()
                
            } else {
                // Token is not available
                
                // Create Data Task
                let dataTask = session.dataTask(with: url!) { data, response, error in
                    
                    self.userDataTask(data: data, responce: response, error: error)
                    
                }
                
                // Start the Data Task
                dataTask.resume()
                
            }
            
        }
        
    }
    
    func getReposApi(currentPage: Int, reposUrl: String?, id: Int?) {
        
        guard reposUrl != nil && id != nil else {
            return
        }
        
        // Create URL
        var urlComponents = URLComponents(string: reposUrl!)
        urlComponents?.queryItems = [
            URLQueryItem(name: "page", value: String(currentPage)),
            URLQueryItem(name: "per_page", value: String(Constants.API.repoPaginationStep))
        ]
        
        let url = urlComponents?.url
        
        // Create request
        if url == url {
            
            // Get URL session
            let session = URLSession.shared
            
            // Check if possible to use GitHub REST API (I added here this if statment because REST API let more requests)
            if Constants.API.apiToken != "" {
                
                // Create request
                var request = URLRequest(url: url!, timeoutInterval: 4.0)
                
                request.httpMethod = "GET"
                
                request.addValue("Bearer \(Constants.API.apiToken)", forHTTPHeaderField: "Authorization")
                
                // Create Data Task
                let dataTask = session.dataTask(with: request) { data, response, error in
                    
                    self.repoDataTask(data: data, responce: response, error: error, id: id)
                    
                }
                dataTask.resume()
                
            } else {
                
                // Create Data Task
                let dataTask = session.dataTask(with: url!) { data, response, error in
                    
                    self.repoDataTask(data: data, responce: response, error: error, id: id)
                    
                }
                dataTask.resume()
                
            }
            
        }
        
    }
    
    func userDataTask(data: Data?, responce: URLResponse?, error: Error?) {
        
        if error == nil {
            
            do {
                //Parse JSON
                let result = try JSONDecoder().decode([User].self, from: data!)
                
                // Check if all users are parsed
                if result.isEmpty {
                    self.isUsersFull = true
                    return
                } else if result.count < Constants.API.userPaginantionStep {
                    self.isUsersFull = true
                }
                
                DispatchQueue.main.async {
                    
                    for user in result {
                        // Check if user is not in users array
                        if !self.users.contains(where: { $0.id == user.id}) {
                            self.users.append(user)
                            self.addUser(id: user.id, login: user.login, avatarUrl: user.avatarUrl, reposUrl: user.reposUrl)
                        }
                        
                        //Call the getImage function for the users
                        user.getImageData()
                    }
                    
                    self.currentPage += Constants.API.userPaginantionStep
                }
            }
            catch {
                print(error)
            }
            
        }
        
    }
    
    func repoDataTask(data: Data?, responce: URLResponse?, error: Error?, id: Int?) {
        
        if error == nil {
            
            do {
                // Parse JSON
                let result = try JSONDecoder().decode([Repo].self, from: data!)
                
                DispatchQueue.main.async {
                    
                    // Find the user by the id
                    for user in self.users {
                        if user.id == id {
                            
                            // Check if all repos of the user are parsed
                            if result.isEmpty {
                                user.isReposFull = true
                                return
                            } else if result.count < Constants.API.repoPaginationStep {
                                user.isReposFull = true
                            }
                            
                            for repo in result {
                                // Check if repo doesn't exist yet
                                if !user.repos.contains(where: { $0.id == repo.id}) {
                                    
                                    // Add new repo
                                    user.repos.append(repo)
                                    
                                    // Save new repo to the databaser
                                    self.addRepo(id: repo.id, name: repo.name, createdAt: repo.createdAt, updatedAt: repo.updatedAt, language: repo.language, userId: user.id)
                                }
                            }
                            
                            user.currenPage += Constants.API.repoPaginationStep
                            
                        }
                    }
                }
                
            }
            catch {
                print(error)
            }
            
        }
        
    }
    
    func loadMoreUsers() {
        
        getUsersApi(currentPage: currentPage)
        
    }
    
    // MARK: - SQLite methods
    
    func setDatabase() {
        
        do {
            // Create users table if it doesn't exist
            try db!.run(Constants.UsersDB.usersTable.create(ifNotExists: true) { t in
                
                t.column(Constants.UsersDB.id, primaryKey: true)
                t.column(Constants.UsersDB.login)
                t.column(Constants.UsersDB.avatarUrl)
                t.column(Constants.UsersDB.reposUrl)
                
            })
            
            // Create repos table if it doesn't exist
            try db!.run(Constants.ReposDB.reposTable.create(ifNotExists: true) { t in
                
                t.column(Constants.ReposDB.id, primaryKey: true)
                t.column(Constants.ReposDB.name)
                t.column(Constants.ReposDB.createdAt)
                t.column(Constants.ReposDB.updatedAt)
                t.column(Constants.ReposDB.language)
                t.column(Constants.ReposDB.userId)
                
            })
            
        }
        catch {
            // Couldn't execute setting of tables
            print("Couldn't set tables: \(error.localizedDescription)")
        }
        
    }
    
    func addUser(id: Int?, login: String?, avatarUrl: String?, reposUrl: String?) {
        
        guard id != nil else {
            return
        }
        
        do {
            // Add user to the database
            try db!.run(Constants.UsersDB.usersTable.insert(
                Constants.UsersDB.id <- id!,
                Constants.UsersDB.login <- login ?? "",
                Constants.UsersDB.avatarUrl <- avatarUrl ?? "",
                Constants.UsersDB.reposUrl <- reposUrl ?? ""
            ))
            
        }
        catch {
            // Couldn't execute selecting of users
            print("Couldn't add user: \(error.localizedDescription)")
        }
        
    }
    
    func getUsersSQLite() {
        
        do {
            // Get users from the database
            for item in try db!.prepare(Constants.UsersDB.usersTable) {
                
                let user = User()
                
                user.id = item[Constants.UsersDB.id]
                user.login = item[Constants.UsersDB.login]
                user.avatarUrl = item[Constants.UsersDB.avatarUrl]
                user.reposUrl = item[Constants.UsersDB.reposUrl]
                user.getImageData()
                
                self.users.append(user)
                
            }
            
        }
        catch {
            // Couldn't execute selecting of users
            print("Couldn't get users: \(error.localizedDescription)")
        }
    }
    
    func addRepo(id: Int?, name: String?, createdAt: String?, updatedAt: String?, language: String?, userId: Int?) {
        
        guard id != nil || userId != nil else {
            return
        }
        
        do {
            // Add repo to the database
            try db!.run(Constants.ReposDB.reposTable.insert(
                Constants.ReposDB.id <- id!,
                Constants.ReposDB.name <- name ?? "",
                Constants.ReposDB.createdAt <- createdAt ?? "",
                Constants.ReposDB.updatedAt <- updatedAt ?? "",
                Constants.ReposDB.language <- language ?? "",
                Constants.ReposDB.userId <- userId!
            ))
            
        }
        catch {
            // Couldn't execute selecting of users
            print("Couldn't add repo: \(error.localizedDescription)")
        }
        
    }
    
    func getReposSQLite(id: Int?) {
        
        guard id != nil else {
            return
        }
        
        do {
            // Get users from the database
            let query = Constants.ReposDB.reposTable
                .filter(Constants.ReposDB.userId == id!)
            
            for item in try db!.prepare(query) {
                
                let repo = Repo()
                
                repo.id = item[Constants.ReposDB.id]
                repo.name = item[Constants.ReposDB.name]
                repo.createdAt = item[Constants.ReposDB.createdAt]
                repo.updatedAt = item[Constants.ReposDB.updatedAt]
                repo.language = item[Constants.ReposDB.language]
                
                for user in self.users{
                    
                    // Find a user by the id
                    if user.id == id {
                        
                        // Check if repo has't been featched bafore
                        if !user.repos.contains(where: { $0.id == repo.id}) {
                            user.repos.append(repo)
                        }
                        
                    }
                    
                }
                
            }
            
        }
        catch {
            // Couldn't execute selecting of users
            print("Couldn't get repos: \(error.localizedDescription)")
        }
        
    }
    
}
