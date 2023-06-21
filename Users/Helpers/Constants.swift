//
//  Constants.swift
//  Users
//
//  Created by Bohdan Zhyzhchenko on 19.06.2023.
//

import Foundation
import SQLite

struct Constants {
    
    struct API {
        
        static var apiToken = ""
        static var usersUrl = "https://api.github.com/users"
        
        static var userPaginantionStep = 11
        static var repoPaginationStep = 11
        
    }
    
    struct UsersDB {
        
        static var usersTable = Table("users")
        
        static var id = Expression<Int>("id")
        static var login = Expression<String?>("login")
        static var avatarUrl = Expression<String?>("avatarUrl")
        static var reposUrl = Expression<String?>("reposUrl")
        
    }

    struct ReposDB {
        
        static var reposTable = Table("repos")
        
        static var id = Expression<Int>("id")
        static var name = Expression<String?>("name")
        static var createdAt = Expression<String?>("createdAt")
        static var updatedAt = Expression<String?>("updatedAt")
        static var language = Expression<String?>("language")
        
        // Column to bind ReposDB to UsersDB
        static var userId = Expression<Int>("userId")
        
    }

    
}
