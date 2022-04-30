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
    func setupNoti()
    func setupView()

    func reloadTableView()
    func pushToWriteViewController()
    func pushToDetailViewController(_ memo: Memo)
    func showListPopupViewController(_ popoverContentController: ListPopupViewController)
    func showPasswordAlertViewController(_ memo: Memo)
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
        viewController?.setupNoti()
        viewController?.setupView()
    }

    func viewWillAppear() {
        memos = userDefaultsManager.getMemos()
        viewController?.reloadTableView()
    }

    func didTappedLeftBarButton(_ sender: UIBarButtonItem) {
        let popoverContentController = ListPopupViewController()
        popoverContentController.modalPresentationStyle = .popover
        popoverContentController.preferredContentSize = CGSize(width: 80, height: 100)

        if let popoverPresentationController = popoverContentController.popoverPresentationController {
            popoverPresentationController.permittedArrowDirections = .right
            popoverPresentationController.barButtonItem = sender
            popoverPresentationController.delegate = self
            viewController?.showListPopupViewController(popoverContentController)
        }
    }

    func didTappedRightBarButton() {
        viewController?.pushToWriteViewController()
    }

    func showMemoNoti(_ notification: Notification) {
        guard let memo = notification.object as? Memo else { return }

        viewController?.pushToDetailViewController(memo)
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

    /// 행 구성
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ListTableViewCell.identifier
        ) as? ListTableViewCell else { return UITableViewCell() }

        let memo = memos[indexPath.row]
        cell.update(memo)

        return cell
    }

    /// 행 높이
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }

    /// 행 클릭
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let memo = memos[indexPath.row]
        if memo.isSecret {
            viewController?.showPasswordAlertViewController(memo)
        }
        viewController?.pushToDetailViewController(memo)
    }
}

// MARK: - UIPopoverPresentationControllerDelegate
extension ListPresenter: UIPopoverPresentationControllerDelegate {

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

    func popoverPresentationControllerDidDismissPopover(
        _ popoverPresentationController: UIPopoverPresentationController
    ) {

    }

    func popoverPresentationControllerShouldDismissPopover(
        _ popoverPresentationController: UIPopoverPresentationController
    ) -> Bool {
        return true
    }
}
