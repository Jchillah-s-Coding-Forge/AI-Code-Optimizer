import Foundation

class GeminiAPI {
    static let shared = GeminiAPI()
    private let baseURL = "http://localhost:3000/ask-gemini"

    func sendPrompt(_ prompt: String, completion: @escaping (String?) -> Void) {
        guard let url = URL(string: baseURL) else {
            completion(nil)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody = ["prompt": prompt]
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)

        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            let response = try? JSONDecoder().decode(GeminiResponse.self, from: data)
            completion(response?.response)
        }.resume()
    }
}
