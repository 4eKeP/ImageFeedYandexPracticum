//
//  OAuth2Service.swift
//  ImageFeedYandexPracticum
//
//  Created by admin on 04.10.2023.
//

import Foundation

final class OAuth2Service {
    static let shared = OAuth2Service()
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String?
    
    private var authToken: String? {
        get {
            return OAuth2TokenStorage().token
        }
        set {
            OAuth2TokenStorage().token = newValue
        }
    }
    
    func fetchOAuthToken(
        _ code: String,
        completion: @escaping (Result<String, Error>) -> Void ){
            
            assert(Thread.isMainThread)
            if lastCode == code { return }
            task?.cancel()
            lastCode = code
            
            let request = authTokenRequest(code: code)
            let task = urlSession.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    switch result {
                    case .success(let body):
                        let authToken = body.accessToken
                        self.authToken = authToken
                        completion(.success(authToken))
                        self.task = nil
                    case .failure(let error):
                        self.lastCode = nil
                        completion(.failure(error))
                    }
                }
            }
            self.task = task
            task.resume()
        }
}

extension OAuth2Service {
    private func authTokenRequest(code: String) -> URLRequest {
        URLRequest.makeHTTPRequest(
            path: "/oauth/token"
            + "?client_id=\(AuthConfiguration.standard.accessKey)"
            + "&&client_secret=\(AuthConfiguration.standard.secretKey)"
            + "&&redirect_uri=\(AuthConfiguration.standard.redirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            httpMethod: "POST",
            baseURL: URL(string: "https://unsplash.com")!
        ) }
    
    private struct OAuthTokenResponseBody: Decodable {
        let accessToken: String
        let tokenType: String
        let scope: String
        let createdAt: Int
    }
}




