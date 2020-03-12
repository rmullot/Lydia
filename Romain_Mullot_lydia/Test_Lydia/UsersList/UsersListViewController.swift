//
//  UsersListViewController.swift
//  Test_Lydia
//
//  Created by Romain Mullot on 01/02/2020.
//  Copyright © 2020 Romain Mullot. All rights reserved.
//

import UIKit
import LydiaUIKit

final class UsersListViewController: UIViewController {

    private let userHeightRow: CGFloat = 115

    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl.autolayout()
        refreshControl.addTarget(self, action: .pullToRefresh, for: UIControl.Event.valueChanged)
        return refreshControl
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView.autolayout()
        tableView.backgroundColor = .white
        tableView.accessibilityIdentifier = "UsersListViewController_tableView"
        tableView.isOpaque = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.estimatedRowHeight = userHeightRow
        tableView.registerReusableCell(UserCell.self)
        tableView.registerReusableCell(LoadingCell.self)
        tableView.addSubview(refreshControl)
        return tableView
    }()

    private let viewModel: UsersViewModelProtocol

    // MARK: - Memory Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        viewModel.refreshUserList()
    }

    init(viewModel: UsersViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        viewModel.needRefresh = nil
    }

}

// MARK: - Action Methods

extension UsersListViewController {

    @objc
    func pullToRefresh(_ sender: UIButton) {
        viewModel.refreshUserList()
    }
}

// MARK: - Setup Methods

private extension UsersListViewController {

    func setup() {
        view.isOpaque = true
        viewModel.needRefresh = { [weak self] newIndexPathsToLoad in

            guard let strongSelf = self else { return }
            guard let newIndexPathsToLoad = newIndexPathsToLoad else {
                strongSelf.tableView.reloadData()
                return
            }
            strongSelf.tableView.insertRows(at: newIndexPathsToLoad, with: .left)
            strongSelf.refreshControl.endRefreshing()
        }
        setupInterface()
        setupConstraints()
    }

    func setupInterface() {
        view.addSubview(tableView)
    }

    func setupConstraints() {
        tableView.anchorToBounds(view: view)
    }
}

// MARK: - UITableViewDelegate Methods

extension UsersListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return userHeightRow
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}

// MARK: - UITableViewDataSource Methods

extension UsersListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.usersCount
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if viewModel.needLoading(index: indexPath) {
            let cell = tableView.dequeueReusableCell(LoadingCell.self, indexPath: indexPath)
            cell.config()
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(UserCell.self, indexPath: indexPath)
            cell.config(viewModel: viewModel, index: indexPath.row)
            return cell
        }

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didTapUser(index: indexPath.row)
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }

}

extension UsersListViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: viewModel.needLoading) {
            viewModel.refreshUserList()
        }
    }
}

// MARK: - Selector Methods

private extension Selector {
    static let pullToRefresh = #selector(UsersListViewController.pullToRefresh(_:))
}
