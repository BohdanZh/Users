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
            
            ZStack(alignment: .bottom) {
                Rectangle()
                    .cornerRadius(10)
                    .ignoresSafeArea()
                    .foregroundColor(.white)
                    .frame(height: 100)
                    .shadow(radius: 5)
                UserRowView(user: user, imageSize: 80, loginFont: .title)
                    .padding(10)
            }
            .padding(.bottom, 5)
            
            ScrollView {
                
                LazyVStack (alignment: .center) {
                    
                    ForEach(user.repos) { repo in
                        RepoRowView(repo: repo)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 5)
                    }
                    
                    if user.isReposFull == false {
                        ProgressView()
                            .onAppear {
                                model.getReposSQLite(id: user.id)
                                model.getReposApi(currentPage: user.currenPage, reposUrl: user.reposUrl, id: user.id)
                            }
                    }
                    
                }
                
            }
        }
        
    }
}
