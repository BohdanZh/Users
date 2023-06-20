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
                    LazyVStack (alignment: .center) {
                        
                        ForEach(model.users) { user in
                            NavigationLink {
                                RepoListView(user: user)
                                    .onAppear{
                                        if user.repos.isEmpty {
                                            model.getReposAPI(currentPage: user.currenPage, reposUrl: user.reposUrl, id: user.id)
                                        }
                                    }
                            } label: {
                                UserRowView(user: user)
                            }
                        }
                        
                        ProgressView()
                            .onAppear {
                                model.loadMoreUsers()
                            }
                        
                    }
                }
            }
            .padding(.leading)
        }
        
    }
}
