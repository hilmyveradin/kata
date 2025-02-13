//
//  OpenAIService.swift
//  Arti-v2
//
//  Created by Hilmy Veradin on 12/07/24.
//

import Foundation

struct OpenAIRequest: Codable {
    let model: String
    let messages: [Message]
}

struct Message: Codable {
    let role: String
    let content: String
}

struct OpenAIResponse: Codable {
    let choices: [Choice]
}

struct Choice: Codable {
    let message: Message
}

// Define custom errors
enum OpenAIServiceError: Error {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
    case apiError(String)
}

class OpenAIService {
    private let apiKey: String = SECRETS.OpenAIKey
    private let baseURL = "https://api.openai.com/v1/chat/completions"

    func chatbotInteraction(messages: [Message], selectedLanguage: SelectedLanguage, completion: @escaping (Result<String, OpenAIServiceError>) -> Void) {
        let systemPrompt = "You are a language learning assistant for \(selectedLanguage.rawValue). Respond in the following format:({YOUR ANSWER IN GIVEN LANGUAGE}\n----------\n{INDONESIAN TRANSLATION}\n) The () is just to make sure that the response is that. Then, you should Provide explanations and corrections when necessary. format: explanations and corrections is format:(\n{LANGUAGE}\n----------\n{INDONESIAN TRANSLATION}\n) The () is just to make sure that the response is that. Then, you should ask a follow up question that encourages users to ask more. The format is the same: format:(\n{LANGUAGE}\n----------\n{INDONESIAN TRANSLATION}\n)"

        var allMessages = [Message(role: "system", content: systemPrompt)]
        allMessages.append(contentsOf: messages)

        let request = OpenAIRequest(
            model: "gpt-4o",
            messages: allMessages
        )

        performRequest(request: request, completion: completion)
    }

    func translate(text: String?, origin: SelectedLanguage, destination: SelectedLanguage, completion: @escaping (Result<String, OpenAIServiceError>) -> Void) {
        guard let text = text else {
            completion(.failure(.apiError("No sound detected")))
            return
        }

        let systemPrompt = "Translate the following text from \(origin.rawValue) to \(destination.rawValue). Remove any quotation marks in the response."

        let request = OpenAIRequest(
            model: "gpt-4o",
            messages: [
                Message(role: "system", content: systemPrompt),
                Message(role: "user", content: text),
            ]
        )

        performRequest(request: request, completion: completion)
    }

    private func performRequest(request: OpenAIRequest, completion: @escaping (Result<String, OpenAIServiceError>) -> Void) {
        guard let url = URL(string: baseURL) else {
            completion(.failure(.invalidURL))
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            urlRequest.httpBody = try JSONEncoder().encode(request)
        } catch {
            completion(.failure(.apiError("Failed to encode request: \(error.localizedDescription)")))
            return
        }

        URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }

            guard let data = data else {
                completion(.failure(.apiError("No data received")))
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(OpenAIResponse.self, from: data)
                if let translatedText = decodedResponse.choices.first?.message.content {
                    completion(.success(translatedText))
                } else {
                    completion(.failure(.apiError("No translation found in the response")))
                }
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }.resume()
    }
}
