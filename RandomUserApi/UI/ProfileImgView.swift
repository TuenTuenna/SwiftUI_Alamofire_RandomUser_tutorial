//
//  ProfileImgView.swift
//  RandomUserApi
//
//  Created by Jeff Jeong on 2021/03/10.
//

import Foundation
import SwiftUI
import URLImage

struct ProfileImgView : View {
    
    var imageUrl: URL
    
    var body: some View {
        URLImage(url: imageUrl,
                 content: { image in
                     image
                         .resizable()
                         .aspectRatio(contentMode: .fit)
                 })
            .frame(width: 50, height: 60)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.init(#colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)), lineWidth: 2))
    }
}


struct ProfileImgView_Previews: PreviewProvider {
    static var previews: some View {
        
        let url = URL(string: "https://randomuser.me/api/portraits/women/21.jpg")!
        
        ProfileImgView(imageUrl: url)
    }
}
