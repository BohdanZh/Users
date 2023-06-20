//
//  Models.swift
//  Users
//
//  Created by Bohdan Zhyzhchenko on 19.06.2023.
//

import Foundation

class User: Identifiable, Decodable, ObservableObject {
    
    @Published var image: Data?
    @Published var repos = [Repo]()
    
    var id: Int?
    var login: String?
    var avatarUrl: String?
    var reposUrl: String?
    
    enum CodingKeys: String, CodingKey {
        
        case avatarUrl = "avatar_url"
        case reposUrl = "repos_url"
        
        case id
        case login
        
    }
    
    func getImageData() {
        
        //Check that image url isn't nil
        guard avatarUrl != nil else {
            return
        }
        
        //Download the data fo the image
        if let url = URL(string: avatarUrl!) {
            
            //Get a session
            let session = URLSession.shared
            let dataTask = session.dataTask(with: url) { data, response, error in
                
                if error == nil {
                    
                    DispatchQueue.main.async {
                        //Set the image data
                        self.image = data!
                    }
                }
            }
            dataTask.resume()
        }
    }
    
    func getReposAPI() {
        
        guard reposUrl != nil else {
            return
        }
        
        // Create request
        if let url = URL(string: reposUrl!) {
            
            // Get URL session
            let session = URLSession.shared
            
            // Create Data Task
            let dataTask = session.dataTask(with: url) { data, response, error in
                
                if error == nil {
                    
                    do {
                        //Parse JSON
                        let result = try JSONDecoder().decode([Repo].self, from: data!)
                        //print(result)
                        
                        DispatchQueue.main.async {
                            for repo in result {
                                // Check if user is not in users array
                                if !self.repos.contains(where: { $0.id == repo.id}) {
                                    self.repos.append(repo)
                                    
                                    // TODO: Add repos to Sqlite
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
}

struct Repo: Decodable {
    
    var id: Int?
    var name: String?
    var createdAt: Date?
    var updatedAt: Date?
    var language: String?
    
    enum CodingKeys: String, CodingKey {
        
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        
        case id
        case name
        case language
        
    }
}
