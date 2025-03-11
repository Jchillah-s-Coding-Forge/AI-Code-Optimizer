import Foundation

class OpenAICodeOptimizerService {
    static let shared = OpenAICodeOptimizerService()
    private let apiKey = "DEIN_OPENAI_API_KEY"

    private init() {}

    func optimize(code: String, language: String) async -> String {
        let endpoint = "https://api.openai.com/v1/chat/completions"
        let payload: [String: Any] = [
            "model": "gpt-4",
            "messages": [
                ["role": "system", "content": "Du bist ein hilfreicher Code-Optimierer für \(language)."],
                ["role": "user", "content": "Optimiere diesen Code:\n\(code)"]
            ],
            "temperature": 0.3
        ]

        do {
            var request = URLRequest(url: URL(string: endpoint)!)
            request.httpMethod = "POST"
            request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONSerialization.data(withJSONObject: payload)

            let (data, _) = try await URLSession.shared.data(for: request)
            let response = try JSONDecoder().decode(OpenAIResponse.self, from: data)

            return response.choices.first?.message.content ?? "Fehler: Keine Antwort erhalten."
        } catch {
            return "Fehler: \(error.localizedDescription)"
        }
    }
}

struct OpenAIResponse: Decodable {
    struct Choice: Decodable {
        struct Message: Decodable {
            let content: String
        }
        let message: Message
    }
    let choices: [Choice]
}
