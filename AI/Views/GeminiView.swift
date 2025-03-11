import SwiftUI

struct GeminiView: View {
    @State private var userInput = ""
    @State private var geminiResponse: String = "Antwort erscheint hier..."
    @State private var isLoading = false

    var body: some View {
        VStack(spacing: 20) {
            Text("AI Chat")
                .font(.title)
                .bold()

            TextField("Frage eingeben...", text: $userInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                isLoading = true
                GeminiAPI.shared.sendPrompt(userInput) { response in
                        geminiResponse = response ?? "Fehler bei der Antwort"
                        isLoading = false
                }
            }) {
                if isLoading {
                    ProgressView()
                } else {
                    Text("Senden")
                        .bold()
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }

            Text(geminiResponse)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
        }
        .padding()
    }
}

#Preview {
    GeminiView()
}
