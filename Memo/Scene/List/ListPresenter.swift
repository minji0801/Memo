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
    func pushToWriteViewController()
}

final class ListPresenter: NSObject {
    private let viewController: ListProtocol?

    init(viewController: ListProtocol?) {
        self.viewController = viewController
    }

    func viewDidLoad() {
        viewController?.setupNavigationBar()
        viewController?.setupView()
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
        return 3
    }

    /// 셀 구성
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ListTableViewCell.identifier
        ) as? ListTableViewCell else { return UITableViewCell() }

        cell.update(indexPath.row)

        return cell
    }
}
