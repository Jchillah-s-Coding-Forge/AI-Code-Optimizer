//
//  EditorView.swift
//  AI
//
//  Created by Michael Winkler on 11.03.25.
//

import SwiftUI

struct EditorView: View {
    @State private var codeText: String = "// Hier kannst du Code eingeben"
    
    var body: some View {
        VStack {
            Text("Editor")
                .font(.title)
                .padding()
            
            TextEditor(text: $codeText)
                .padding()
                .border(Color.gray, width: 1)
                .frame(height: 300)
        }
        .padding()
    }
}

#Preview {
    EditorView()
}
