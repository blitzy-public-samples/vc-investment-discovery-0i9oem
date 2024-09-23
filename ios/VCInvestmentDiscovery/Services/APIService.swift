import Foundation
import Combine

enum APIError: Error {
    case invalidURL, requestFailed, decodingFailed
}

class APIService {
    private let baseURL: String
    private let session: URLSession
    private let decoder: JSONDecoder

    init(baseURL: String, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
        self.decoder = JSONDecoder()
    }

    func request(endpoint: String, method: HTTPMethod = .get, parameters: [String: Any]? = nil, headers: [String: String]? = nil) -> AnyPublisher<Data, Error> {
        guard let url = URL(string: baseURL + endpoint) else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }

        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        if let parameters = parameters, method == .get {
            urlComponents?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        }

        guard let finalURL = urlComponents?.url else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }

        var request = URLRequest(url: finalURL)
        request.httpMethod = method.rawValue
        headers?.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }

        if let parameters = parameters, method != .get {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        return session.dataTaskPublisher(for: request)
            .mapError { _ in APIError.requestFailed }
            .map(\.data)
            .eraseToAnyPublisher()
    }

    func get<T: Decodable>(_ endpoint: String, parameters: [String: Any]? = nil, headers: [String: String]? = nil) -> AnyPublisher<T, Error> {
        return request(endpoint: endpoint, method: .get, parameters: parameters, headers: headers)
            .decode(type: T.self, decoder: decoder)
            .eraseToAnyPublisher()
    }

    func post<T: Decodable>(_ endpoint: String, body: Encodable, headers: [String: String]? = nil) -> AnyPublisher<T, Error> {
        do {
            let encodedBody = try JSONEncoder().encode(body)
            var allHeaders = headers ?? [:]
            allHeaders["Content-Type"] = "application/json"
            
            return request(endpoint: endpoint, method: .post, parameters: nil, headers: allHeaders)
                .decode(type: T.self, decoder: decoder)
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }

    func put<T: Decodable>(_ endpoint: String, body: Encodable, headers: [String: String]? = nil) -> AnyPublisher<T, Error> {
        do {
            let encodedBody = try JSONEncoder().encode(body)
            var allHeaders = headers ?? [:]
            allHeaders["Content-Type"] = "application/json"
            
            return request(endpoint: endpoint, method: .put, parameters: nil, headers: allHeaders)
                .decode(type: T.self, decoder: decoder)
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }

    func delete<T: Decodable>(_ endpoint: String, headers: [String: String]? = nil) -> AnyPublisher<T, Error> {
        return request(endpoint: endpoint, method: .delete, headers: headers)
            .decode(type: T.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}