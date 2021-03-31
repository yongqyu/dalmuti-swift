//
//  CircleImageView.swift
//  dalva
//
//  Created by keith.gotkeys on 2021/03/29.
//

import SwiftUI

struct CircleImageView : View {
    var body: some View {

        Circle()
            .fill(Color.white)
            .padding()
            .background(Color.gray)
            .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
        
    }
}

struct CircleImageView_Previews: PreviewProvider {
    static var previews: some View {
        CircleImageView()
    }
}
