//
//  AuthViewController.swift
//  ImageFeedYandexPracticum
//
//  Created by admin on 01.10.2023.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}

final class AuthViewController: UIViewController {
    weak var delegate: AuthViewControllerDelegate?
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    @IBOutlet private weak var authButton: UIButton!
    
    private let segueToLoginScreenName = "ShowWebView"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authButton.accessibilityIdentifier = "Authenticate"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueToLoginScreenName {
            guard let webViewController = segue.destination as? WebViewViewController
            else { fatalError("Failed to prepare for \(segueToLoginScreenName)") }
            let authHelper = AuthHelper()
            let webViewPresenter = WebViewPresenter(authHealper: authHelper)
            webViewController.presenter = webViewPresenter
            webViewPresenter.view = webViewController
            webViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        delegate?.authViewController(self, didAuthenticateWithCode: code)
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
