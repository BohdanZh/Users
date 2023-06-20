//
//  UserRowView.swift
//  Users
//
//  Created by Bohdan Zhyzhchenko on 20.06.2023.
//

import SwiftUI

struct UserRowView: View {
    
    @ObservedObject var user:User
    
    var imageSize: CGFloat = 58
    var loginFont: Font = .body
    
    var body: some View {
        
        HStack(spacing: 20) {
            // Image
            let uiImage = UIImage(data: user.image ?? Data())
            Image(uiImage: uiImage ?? UIImage())
                .resizable()
                .frame(width: imageSize, height: imageSize)
                .cornerRadius(20)
                .scaledToFit()
            
            // Username
            Text(user.login?.capitalized ?? "")
                .foregroundColor(.black)
                .font(loginFont)
                .bold()
            
            Spacer()
        }
    }
    
}
