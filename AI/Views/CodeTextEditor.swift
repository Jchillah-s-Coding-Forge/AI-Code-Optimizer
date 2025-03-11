import SwiftUI

struct CodeTextEditor: View {
    @Binding var code: String
    @Binding var previousVersions: [String]
    
    var body: some View {
        TextEditor(text: $code)
            .textInputAutocapitalization(.never)
            .font(.system(.body, design: .monospaced))
            .padding()
            .background(Color(UIColor.systemBackground))
            .onChange(of: code) { _, newValue in
                previousVersions.append(newValue)
            }
            .frame(height: 300)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))
            .padding()
    }
}

#Preview {
    @Previewable @State var code = "// Write your code here..."
    @Previewable @State var previousVersions: [String] = []
    
    return CodeTextEditor(code: $code, previousVersions: $previousVersions)
}

