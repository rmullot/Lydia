//
//  WebService.swift
//  LydiaAPI
//
//  Created by Romain Mullot on 04/03/2020.
//  Copyright © 2020 Romain Mullot. All rights reserved.
//

import LydiaNetwork
import SwiftMessages

public protocol APIServiceProtocol: APIUsersProtocol {
    func cancelRequests()
}

public enum WebServiceErrorMessage: Swift.Error {
       case noNetwork
       case invalidURL
       case unknownError
       case badObjectType
       case customMessage(String?)
   }

public final class APIService: APIServiceProtocol {

    // MARK: Attributes

    internal enum TypeWebService {
        case users
        case categories
    }

    internal let uri = "https://randomuser.me/api/?page=%d&results=10&seed=919b9c876d9d40b4"

    public var onlineMode: OnlineMode = .online

    internal var pagination = 0

    public static let sharedInstance = APIService()

    // MARK: - Public Methods

    public func cancelRequests() {
        URLSession.shared.getTasksWithCompletionHandler { (dataTask, uploadTask, downloadTask) in
            for task in dataTask {
                task.cancel()
            }
            for task in uploadTask {
                task.cancel()
            }
            for task in downloadTask {
                task.cancel()
            }
            NetworkActivityService.sharedInstance.disableActivityIndicator()
        }
    }

    private init() {
        ReachabilityService.sharedInstance.delegates.add(self)
    }

    deinit {
        ReachabilityService.sharedInstance.delegates.remove(self)
    }

}

// MARK: - Private Methods

internal extension APIService {

    func getDataWith(urlString: String, type: TypeWebService, completion: @escaping (Result<Data, WebServiceErrorMessage>) -> Void) {
        guard onlineMode != .offline else { return completion(.failure(WebServiceErrorMessage.noNetwork)) }
        guard let url = URL(string: urlString) else { return completion(.failure(WebServiceErrorMessage.invalidURL)) }
        var request = URLRequest(url: url)
        switch type {
        case .users, .categories:
            request.httpMethod = "GET"
        }

        NetworkActivityService.sharedInstance.newRequestStarted()
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            DispatchQueue.main.async {
                NetworkActivityService.sharedInstance.requestFinished()
                guard error == nil else { return completion(.failure(.customMessage(error?.localizedDescription))) }
                guard let data = data else { return completion(.failure(.unknownError)) }
                return completion(.success(data))
            }
        }.resume()
    }

    func displayNetworkStatus() {
      let marginMessageBox: CGFloat = 20
      let view = MessageView.viewFromNib(layout: .cardView)
      switch onlineMode {
      case .offline:
        view.configureTheme(.warning)
        view.configureContent(title: L10n.errorTitle, body: L10n.errorUnavailableNetwork)
      case .onlineSlow:
        view.configureTheme(.warning)
        view.configureContent(title: L10n.errorTitle, body: L10n.badNetworkMessage)
      case .online:
        view.configureTheme(.success)
        view.configureContent(title: L10n.okTitle, body: L10n.networkAvailableMessage)
      }
      SwiftMessages.show {
        view.configureDropShadow()
        view.button?.isHidden = true
        view.layoutMarginAdditions = UIEdgeInsets(top: marginMessageBox, left: marginMessageBox, bottom: marginMessageBox, right: marginMessageBox)
        (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10
        return view
      }
    }
}

// MARK: - ReachabilityManagerDelegate
extension APIService: ReachabilityServiceDelegate {

    public func onlineModeChanged(_ newMode: OnlineMode) {
        if onlineMode != newMode {
            onlineMode = newMode
            displayNetworkStatus()
        }
    }
}
