import SQLite

var greeting = "Hello, playground"


do {
    
    let db = try Connection()
    
    // Create users table if it doesn't exist
    try db.run(Constants.UsersDB.usersTable.create(ifNotExists: true) { t in
        
        t.column(Constants.UsersDB.id, primaryKey: true)
        t.column(Constants.UsersDB.login)
        t.column(Constants.UsersDB.avatarUrl)
        t.column(Constants.UsersDB.reposUrl)
        
    })
    
    for item in try db.prepare(Constants.UsersDB.usersTable) {
        
        let user = User()
        
        user.id = Int(item[Constants.UsersDB.id])
        user.login = item[Constants.UsersDB.login]
        user.avatarUrl = item[Constants.UsersDB.avatarUrl]
        user.reposUrl = item[Constants.UsersDB.reposUrl]
        print(user)
        
    }
    
    try db.run(Constants.UsersDB.usersTable.insert(
        Constants.UsersDB.id <- Int64(1),
        Constants.UsersDB.login <- "login",
        Constants.UsersDB.avatarUrl <- "avatarUrl",
        Constants.UsersDB.reposUrl <- "reposUrl"
    ))
    
}
