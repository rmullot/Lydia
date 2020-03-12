//
//  APIService+Users.swift
//  LydiaAPI
//
//  Created by Romain Mullot on 04/03/2020.
//  Copyright © 2020 Romain Mullot. All rights reserved.
//

import Foundation

public protocol APIUsersProtocol: AnyObject {
    func getUsers(completionHandler: @escaping (Result<[UserJSON], Swift.Error>) -> Void)
}

public extension APIService {

    func getUsers(completionHandler: @escaping (Result<[UserJSON], Swift.Error>) -> Void) {
        let url = String(format: uri, pagination)
        getDataWith(urlString: url, type: .users, completion: { (result) in
            switch result {
            case .success(let data):
                ParserService<ResultJSON>.parse(data, completionHandler: { (result) in
                    switch result {
                    case .success(let result):
                        guard let result = result  else {
                            completionHandler(.failure(WebServiceErrorMessage.badObjectType))
                            return
                        }
                        self.pagination += 1
                        completionHandler(.success(result.users))
                    case .failure(_, let message):
                        completionHandler(.failure(WebServiceErrorMessage.customMessage(message)))
                    }
                })

            case .failure(let message):
                completionHandler(.failure(message))
            }
        })
    }
}
