//
//  RepoRowView.swift
//  Users
//
//  Created by Bohdan Zhyzhchenko on 20.06.2023.
//

import SwiftUI

struct RepoRowView: View {
    
    var repo: Repo
    
    var body: some View {
        
        ZStack {
            Rectangle()
                .cornerRadius(10)
                .foregroundColor(.white)
                .shadow(radius: 2)
            
            HStack(spacing: 20) {
                
                VStack(alignment: .leading) {
                    Text("Name: \(repo.name ?? "")")
                        .font(.headline)
                        .padding(.bottom, 5)
                    
                    Text(repo.language ?? "")
                        .font(.caption)
                        .bold()
                        .padding(.bottom, 5)
                    
                    Text("Created: \(Converter.dateFormatConvertion(from: repo.createdAt ?? ""))")
                        .font(.caption)
                    
                    Text("Last update: \(Converter.dateFormatConvertion(from: repo.updatedAt ?? ""))")
                        .font(.caption)
                }
                
                Spacer()
            }
            .padding(.all)
        }
        
    }
    
}
