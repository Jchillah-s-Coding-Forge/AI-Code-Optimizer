import Foundation

class GeminiCodeOptimizerService {
    static let shared = GeminiCodeOptimizerService()
    private let apiURL = URL(string: "http://127.0.0.1:8000/optimize")!

    /// Analysiert und optimiert den Code über die API
    func optimize(code: String, language: String) async -> String {
        var request = URLRequest(url: apiURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let requestBody = CodeRequest(code: code, language: language)
        request.httpBody = try? JSONEncoder().encode(requestBody)

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                return "Fehler: Ungültige Serverantwort."
            }

            let decodedResponse = try JSONDecoder().decode(CodeResponse.self, from: data)
            if let optimizedCode = decodedResponse.optimized_code {
                return optimizedCode
            } else if let errorMessage = decodedResponse.error {
                return "Fehler: \(errorMessage)"
            }
        } catch {
            return "Fehler bei der Verbindung zur API: \(error.localizedDescription)"
        }

        return "Unbekannter Fehler"
    }
}
