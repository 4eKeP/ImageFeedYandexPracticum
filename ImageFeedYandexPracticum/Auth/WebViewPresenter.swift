//
//  WebViewViewPresenterProtocol.swift
//  ImageFeedYandexPracticum
//
//  Created by admin on 07.11.2023.
//

import Foundation

protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? { get set }
    func viewDidLoad()
}

final class WebViewPresenter: WebViewPresenterProtocol {
    weak var view: WebViewViewControllerProtocol?
    
    func viewDidLoad() {
        var urlComponents = URLComponents(string: Constants.unsplashAuthorizeURLString)
        urlComponents?.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constants.accessScope)
        ]
        guard let url = urlComponents?.url else { return }
        let request = URLRequest(url: url)
        view?.load(request: request)
    }
    
  
}