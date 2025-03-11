//
//  CodeOptimizerService.swift
//  AI
//
//  Created by Michael Winkler on 11.03.25.
//


import Foundation
import GoogleGenerativeAI

class CodeOptimizerService {
    static let shared = CodeOptimizerService()
    private let apiKey = "DEIN_GOOGLE_API_KEY"
    
    private init() {}

    func optimize(code: String, language: String) async -> String {
        let model = GenerativeModel(name: "gemini", apiKey: apiKey)
        
        do {
            let response = try await model.generateContent(code)
            return response.text ?? "Keine Optimierung möglich."
        } catch {
            return "Fehler: \(error.localizedDescription)"
        }
    }
}
