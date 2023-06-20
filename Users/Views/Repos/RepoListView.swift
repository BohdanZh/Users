//
//  RepoListView.swift
//  Users
//
//  Created by Bohdan Zhyzhchenko on 20.06.2023.
//

import SwiftUI

struct RepoListView: View {
    
    @EnvironmentObject var model: ContentModel
    @ObservedObject var user:User
    
    var body: some View {
        
        VStack {
            
            UserRowView(user: user, imageSize: 80, loginFont: .title)
                .padding(.all)
            
            List {
                
                ForEach(user.repos) { repo in
                    Text(repo.name ?? "")
                        .font(.largeTitle)
                }
                
                if user.isReposFull {
                    ProgressView()
                        .onAppear {
                            model.getReposAPI(currentPage: user.currenPage, reposUrl: user.reposUrl, id: user.id)
                        }
                }
                
            }
            .listStyle(.plain)
        }
        
    }
}
