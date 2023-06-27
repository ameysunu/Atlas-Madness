//
//  ChatView.swift
//  AtlasGoogleCloud
//
//  Created by Amey Sunu on 27/06/2023.
//

import SwiftUI

struct ChatView: View {
    var body: some View {
        VStack{
            Text("Hello, World!")
        }
        .onAppear{
            //sendQueryToDialogFlow()
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
