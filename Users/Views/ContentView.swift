//
//  ContentView.swift
//  Users
//
//  Created by Bohdan Zhyzhchenko on 19.06.2023.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        
        List {
            ForEach(model.users) { user in
                Text(user.login ?? "")
            }
            
            ProgressView()
                .progressViewStyle(.circular)
                .onAppear {
                    model.loadMore()
                }
            
        }
        
    }
}
