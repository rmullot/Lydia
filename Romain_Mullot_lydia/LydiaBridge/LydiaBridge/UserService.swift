//
//  UserService.swift
//  LydiaBridge
//
//  Created by Romain Mullot on 04/03/2020.
//  Copyright © 2020 Romain Mullot. All rights reserved.
//

import Foundation

import LydiaCoreData
import LydiaAPI
import CoreData

public protocol UserServiceProtocol: AnyObject {
    func getUsers(completionHandler: @escaping (Result<[User]?, Error>) -> Void)
    func refreshUsers(completionHandler: @escaping (Result<[User]?, Error>) -> Void)
}

public final class UserService: UserServiceProtocol {

    private init() {}

    public static let sharedInstance = UserService()

    public func getUsers(completionHandler: @escaping (Result<[User]?, Error>) -> Void) {
        let sortParameters = [["email": false]]
        // catch and convert
        getUsersFromCoreData(sortParameters: sortParameters, completionHandler: completionHandler)
    }

    public func refreshUsers(completionHandler: @escaping (Result<[User]?, Error>) -> Void) {
        let sortParameters = [["email": false]]
        if APIService.sharedInstance.onlineMode != .offline {
            callWebservice(completionHandler: { [weak self] _ -> Void in
                guard let strongSelf = self else {
                    completionHandler(.failure(WebServiceErrorMessage.unknownError))
                    return
                }
                // catch and convert
                strongSelf.getUsersFromCoreData(sortParameters: sortParameters, completionHandler: completionHandler)
            })
        } else {
            // catch and convert
            getUsersFromCoreData(sortParameters: sortParameters, completionHandler: completionHandler)
        }
    }

}

private extension UserService {

    func getUsersFromCoreData(sortParameters: [[String: Bool]], completionHandler: @escaping (Result<[User]?, Error>) -> Void) {
        CoreDataService.sharedInstance.get(value: UserCoreData.self, isMaincontext: true, predicate: nil, sortParameters: sortParameters) { (result) in
            switch result {
            case .success(let results):
                let users = results?.map({ User(user: $0) })
                completionHandler(.success(users))
            case .failure(let messageError):
                completionHandler(.failure(messageError))
            }
        }
    }

    func callWebservice(completionHandler: @escaping (Result<Bool, Error>) -> Void) {
        APIService.sharedInstance.getUsers(completionHandler: { (result) in
            switch result {
            case .success(let resources):
                CoreDataService.sharedInstance.clearData(UserCoreData.self)
                CoreDataService.sharedInstance.saveUsers(resources)
                completionHandler(.success(true))
            case .failure(let message):
                print(message)
                completionHandler(.failure(message))
            }
        })
    }
}
