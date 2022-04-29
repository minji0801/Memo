//
//  ListPresenter.swift
//  Memo
//
//  Created by 김민지 on 2022/04/29.
//  메모 목록 화면 Presenter

import Foundation
import UIKit

protocol ListProtocol: AnyObject {
    func setupNavigationBar()
    func setupView()

    func reloadTableView()
    func pushToWriteViewController()
}

final class ListPresenter: NSObject {
    private let viewController: ListProtocol?
    private let userDefaultsManager: UserDefaultsManagerProtol

    private var memos: [Memo] = []

    init(
        viewController: ListProtocol?,
        userDefaultsManager: UserDefaultsManagerProtol = UserDefaultsManager()
    ) {
        self.viewController = viewController
        self.userDefaultsManager = userDefaultsManager
    }

    func viewDidLoad() {
        viewController?.setupNavigationBar()
        viewController?.setupView()
    }

    func viewWillAppear() {
        memos = userDefaultsManager.getMemos()
        viewController?.reloadTableView()
    }

    func didTappedRightBarButton() {
        viewController?.pushToWriteViewController()
    }
}

// MARK: - UISearchController
extension ListPresenter: UISearchBarDelegate, UISearchControllerDelegate {
    /// 검색 바 보여졌을 때: 자동 포커싱
    func didPresentSearchController(_ searchController: UISearchController) {
        DispatchQueue.main.async {
            searchController.searchBar.becomeFirstResponder()
        }
    }
}

// MARK: - UITableView
extension ListPresenter: UITableViewDataSource, UITableViewDelegate {
    /// 행 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memos.count
    }

    /// 셀 구성
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ListTableViewCell.identifier
        ) as? ListTableViewCell else { return UITableViewCell() }

        let memo = memos[indexPath.row]
        print(indexPath.row, memo.isSecret)
        cell.update(memo)

        return cell
    }

    /// 행 높이
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
}
