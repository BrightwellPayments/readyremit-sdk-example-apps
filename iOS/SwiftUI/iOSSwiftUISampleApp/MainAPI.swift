import Foundation
import Combine

class API {
    
    static func onAuth(
        senderId: String,
        clientId: String,
        clientSecret: String) -> AnyPublisher<String, RRError> {
            guard let url = URL(string: "https://sandbox-api.readyremit.com/v1/oauth/token") else {
                return Fail(error: .invalidURL).eraseToAnyPublisher()
            }
            let bodyRequest = AuthRequest(clientId: clientId,
                                          clientSecret: clientSecret,
                                          audience: "https://sandbox-api.readyremit.com",
                                          grantType: "client_credentials",
                                          senderId: senderId)
            
            guard let body = try? JSONEncoder().encode(bodyRequest) else {
                return Fail(error: .invalidBody).eraseToAnyPublisher()
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = body
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            return URLSession.shared.dataTaskPublisher(for: request)
                .tryMap { (data, response) in
                    do {
                        let decoder = JSONDecoder()
                        let auth = try decoder.decode(AuthResponse.self, from: data)
                        return auth.token
                    } catch {
                        throw RRError.invalidResponse
                    }
                }.mapError { error -> RRError in
                    if let rrError = error as? RRError {
                        return rrError
                    }
                    return RRError.unknown
                }.eraseToAnyPublisher()
        }
}

enum RRError: Error {
    case unknown
    case invalidURL
    case invalidBody
    case invalidResponse
}

struct AuthRequest: Encodable {
    var clientId: String
    var clientSecret: String
    var audience: String
    var grantType: String
    var senderId: String
    
    enum CodingKeys: String, CodingKey {
        case clientId = "client_id"
        case clientSecret = "client_secret"
        case audience = "audience"
        case grantType = "grant_type"
        case senderId = "sender_id"
    }
}

struct AuthResponse: Decodable {
    let token: String
    
    enum CodingKeys: String, CodingKey {
        case token = "access_token"
    }
}

