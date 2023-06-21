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
            VStack (alignment: .center) {
                
                // Heading
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
                                            model.getReposApi(currentPage: user.currenPage, reposUrl: user.reposUrl, id: user.id)
                                        }
                                    }
                            } label: {
                                UserRowView(user: user)
                            }
                        }
                        
                        // Check if there are more users to load
                        if model.isUsersFull == false {
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
}
