//
//  UserListView.swift
//  Users
//
//  Created by Bohdan Zhyzhchenko on 19.06.2023.
//

import SwiftUI

struct UserListView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        
        NavigationView {
            VStack (alignment: .leading) {
                Text("Users")
                    .font(.title)
                    .bold()
                ScrollView {
                    LazyVStack (alignment: .leading) {
                        ForEach(model.users) { user in
                            NavigationLink {
                                RepoListView(repos: user.repos)
                                    .onAppear{
                                        user.getReposAPI()
                                    }
                            } label: {
                                UserRowView(user: user)
                            }
                        }
                    }
                    
                    ProgressView()
                    
                }
            }
            .padding([.leading, .trailing])
        }
        
    }
}
