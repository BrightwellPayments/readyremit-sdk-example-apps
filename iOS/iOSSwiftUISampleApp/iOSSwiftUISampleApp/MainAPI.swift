import Foundation

class API {

    static func onAuth(
        senderId: String,
        clientId: String,
        clientSecret: String,
        onSuccess: @escaping ((String) -> Void),
        onFailure: @escaping (() -> Void)) {
            guard let url = URL(string: "https://sandbox-api.readyremit.com/v1/oauth/token") else {
                onFailure()
                return
            }
            let bodyRequest = AuthRequest(clientId: clientId, clientSecret: clientSecret, audience: "https://sandbox-api.readyremit.com", grantType: "client_credentials", senderId: senderId)
            guard let body = try? JSONEncoder().encode(bodyRequest) else {
                onFailure()
                return
            }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = body
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let task = URLSession.shared.dataTask(with: request) {data, response, error in
                guard error == nil, let json = data else { return }
                let decoder = JSONDecoder()
                if let auth = try? decoder.decode(AuthResponse.self, from: json) {
                    onSuccess(auth.token)
                } else  {
                    onFailure()
                }
            }
            task.resume()
        }
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

