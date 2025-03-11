import SwiftUI

struct StartView: View {
    @ObservedObject var viewModel: CodeEditorViewModel = .init()
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Text("Code AI Assistant")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                NavigationLink(
                    "Loslegen",
                    destination: CodeEditorView(viewModel: viewModel)
                )
                    .font(.title2)
                    .padding()
                    .buttonStyle(.borderedProminent)
                
                Spacer()
            }
        }
    }
}

#Preview {
    StartView()
}
