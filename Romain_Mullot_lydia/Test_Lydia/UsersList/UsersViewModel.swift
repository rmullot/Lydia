//
//  UsersViewModel.swift
//  Test_Lydia
//
//  Created by Romain Mullot on 05/03/2020.
//  Copyright © 2020 Romain Mullot. All rights reserved.
//

import Foundation
import LydiaBridge
import LydiaCore
import LydiaNetwork

protocol UsersViewModelProtocol: AnyObject {
    var usersCount: Int { get }
    func getIdentity(index: Int) -> String
    func getEmail(index: Int) -> String
    func getPhone(index: Int) -> String
    func getThumbImage(index: Int) -> URL?
    func needLoading(index: IndexPath) -> Bool
    func didTapUser(index: Int)
    func refreshUserList()
    func getUserList()
    init(userService: UserServiceProtocol)
    var delegate: UsersViewModelDelegate? { get set }
    var needRefresh: (([IndexPath]?) -> Void)? { get set }
}

protocol UsersViewModelDelegate: AnyObject {
    func didTapUser(user: User)
}

final class UsersViewModel: UsersViewModelProtocol {

    var needRefresh: (([IndexPath]?) -> Void)?

    weak var delegate: UsersViewModelDelegate?
    private var users: [User] = []
    private let userService: UserServiceProtocol

    init(userService: UserServiceProtocol) {
        self.userService = userService
    }

    var usersCount: Int {
        return  users.count + 1
    }

    func refreshUserList() {
        userService.refreshUsers { [weak self] (result) in
            guard let strongSelf = self else { return }
            var indexPathsToReload: [IndexPath]?
            switch result {
            case .success(let newUsers):
                if let newUsers = newUsers {
                    if strongSelf.users.isNotEmpty {
                         let news = newUsers.filter({ user in !strongSelf.users.contains(where: { user.email == $0.email }) })
                          strongSelf.users.append(contentsOf: news)
                         indexPathsToReload = strongSelf.calculateIndexPathsToReload(from: news)
                    } else {
                        strongSelf.users.append(contentsOf: newUsers)
                         indexPathsToReload = strongSelf.calculateIndexPathsToReload(from: newUsers)
                    }

                }

            default: break
            }
            strongSelf.needRefresh?(indexPathsToReload)
        }
    }

    func getUserList() {
        userService.getUsers { [weak self] (result) in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let newUsers):
                if let newUsers = newUsers {
                    strongSelf.users.append(contentsOf: newUsers)
                    let indexPathsToReload = strongSelf.calculateIndexPathsToReload(from: newUsers)
                    strongSelf.needRefresh?(indexPathsToReload)
                }
            default: break
            }
            strongSelf.needRefresh?(nil)
        }
    }

}

// MARK: - Index methods

extension UsersViewModel {

    func getIdentity(index: Int) -> String {
        return getUser(index: index)?.identity ?? ""
    }

    func getEmail(index: Int) -> String {
        return getUser(index: index)?.email ?? ""
    }

    func getPhone(index: Int) -> String {
        return getUser(index: index)?.phone ?? ""
    }

    func getThumbImage(index: Int) -> URL? {
        let urlString = getUser(index: index)?.imageUrls[UserImageSize.medium.rawValue] ?? ""
        return URL(string: urlString)
    }

    func needLoading(index: IndexPath) -> Bool {
        return index.row >= users.count
    }

    func didTapUser(index: Int) {
        guard let user = getUser(index: index) else { return }
        delegate?.didTapUser(user: user)
    }
}

// MARK: - Private methods

private extension UsersViewModel {

    func getUser(index: Int) -> User? {
        guard users.isValidIndex(index) else { return nil }
        return users[index]
    }

    func calculateIndexPathsToReload(from newUsers: [User]) -> [IndexPath] {
      let startIndex = users.count - newUsers.count
      let endIndex = startIndex + newUsers.count
      return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
}
