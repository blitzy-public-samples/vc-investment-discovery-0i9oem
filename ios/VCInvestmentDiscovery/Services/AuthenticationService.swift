import Foundation
import Combine

enum AuthError: Error {
    case invalidCredentials, tokenExpired, networkError, unknown
}

class AuthenticationService: ObservableObject {
    private let apiService: APIService
    private let keychainService: KeychainService
    @Published private(set) var currentUser: User?
    private var cancellables = Set<AnyCancellable>()
    
    init(apiService: APIService, keychainService: KeychainService) {
        self.apiService = apiService
        self.keychainService = keychainService
        self.currentUser = nil
    }
    
    func signIn(email: String, password: String) -> AnyPublisher<User, AuthError> {
        let signInRequest = SignInRequest(email: email, password: password)
        
        return apiService.post(endpoint: "auth/signin", body: signInRequest)
            .mapError { _ in AuthError.networkError }
            .flatMap { response -> AnyPublisher<User, AuthError> in
                guard let token = response["token"] as? String,
                      let userData = response["user"] as? [String: Any],
                      let user = try? User(from: userData) else {
                    return Fail(error: AuthError.invalidCredentials).eraseToAnyPublisher()
                }
                
                return self.keychainService.store(token: token)
                    .map { _ in user }
                    .mapError { _ in AuthError.unknown }
                    .handleEvents(receiveOutput: { [weak self] user in
                        self?.currentUser = user
                    })
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func signUp(email: String, password: String, firstName: String, lastName: String) -> AnyPublisher<User, AuthError> {
        let signUpRequest = SignUpRequest(email: email, password: password, firstName: firstName, lastName: lastName)
        
        return apiService.post(endpoint: "auth/signup", body: signUpRequest)
            .mapError { _ in AuthError.networkError }
            .flatMap { response -> AnyPublisher<User, AuthError> in
                guard let token = response["token"] as? String,
                      let userData = response["user"] as? [String: Any],
                      let user = try? User(from: userData) else {
                    return Fail(error: AuthError.unknown).eraseToAnyPublisher()
                }
                
                return self.keychainService.store(token: token)
                    .map { _ in user }
                    .mapError { _ in AuthError.unknown }
                    .handleEvents(receiveOutput: { [weak self] user in
                        self?.currentUser = user
                    })
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func signOut() -> AnyPublisher<Void, AuthError> {
        return apiService.post(endpoint: "auth/signout", body: nil)
            .mapError { _ in AuthError.networkError }
            .flatMap { _ -> AnyPublisher<Void, AuthError> in
                return self.keychainService.removeToken()
                    .mapError { _ in AuthError.unknown }
                    .handleEvents(receiveOutput: { [weak self] _ in
                        self?.currentUser = nil
                    })
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func refreshToken() -> AnyPublisher<Void, AuthError> {
        return keychainService.getToken()
            .mapError { _ in AuthError.unknown }
            .flatMap { token -> AnyPublisher<Void, AuthError> in
                return self.apiService.post(endpoint: "auth/refresh", body: ["token": token])
                    .mapError { _ in AuthError.networkError }
                    .flatMap { response -> AnyPublisher<Void, AuthError> in
                        guard let newToken = response["token"] as? String else {
                            return Fail(error: AuthError.unknown).eraseToAnyPublisher()
                        }
                        
                        return self.keychainService.store(token: newToken)
                            .mapError { _ in AuthError.unknown }
                            .eraseToAnyPublisher()
                    }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func getCurrentUser() -> AnyPublisher<User?, Never> {
        return Just(currentUser).eraseToAnyPublisher()
    }
}