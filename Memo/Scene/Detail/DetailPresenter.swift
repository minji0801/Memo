//
//  DetailPresenter.swift
//  Memo
//
//  Created by 김민지 on 2022/04/29.
//  메모 상세 화면 presenter

import Foundation
import UIKit

protocol DetailProtocol: AnyObject {
    func setupNavigationBar()
    func setupNoti()
    func setupGesture()
    func setupView(_ memo: Memo)
    func applyFont()

    func popViewController()
    func showDeleteAlertViewController()
    func showPasswordAlertViewController()
    func updateLockButton(_ isSecret: Bool)
}

final class DetailPresenter: NSObject {
    private let viewController: DetailProtocol?
    private let userDefaultsManager: UserDefaultsManagerProtol

    var memo: Memo

    init(
        viewController: DetailProtocol?,
        userDefaultsManager: UserDefaultsManagerProtol = UserDefaultsManager(),
        memo: Memo
    ) {
        self.viewController = viewController
        self.userDefaultsManager = userDefaultsManager
        self.memo = memo
    }

    func viewDidLoad() {
        viewController?.setupNavigationBar()
        viewController?.setupNoti()
        viewController?.setupGesture()
        viewController?.setupView(memo)
        viewController?.applyFont()
    }

    func didTappedLeftBarButton(_ content: String?) {
        guard let content = content else { return }

        if content.isEmpty {
            // 내용이 비었으면 메모 삭제하기
            deleteMemoNoti()
            return
        }

        // 내용이 있으면 변경된 내용으로 저장하기
        let newvalue = Memo(id: memo.id, content: content, password: memo.password, isSecret: memo.isSecret)
        userDefaultsManager.editMemo(memo.id, newvalue)

        viewController?.popViewController()
    }

    func didTappedMenuRightBarButton(_ sender: UIBarButtonItem) {
        viewController?.showDeleteAlertViewController()
    }

    func didTappedLockRightBarButton() {
        if memo.isSecret {
            // 이미 비밀 메모로 설정했으니까 일반 메모로 바꾸기
            memo.isSecret = false
            memo.password = ""
            viewController?.updateLockButton(memo.isSecret)
        } else {
            // 일반 메모에서 비밀메모로 바꾸기
            viewController?.showPasswordAlertViewController()
        }
    }

    func deleteMemoNoti() {
        let id = memo.id
        userDefaultsManager.deleteMemo(id)
        viewController?.popViewController()
    }

    func inputPasswordNoti(_ notification: Notification) {
        guard let object = notification.object as? String else { return }

        memo.password = object
        memo.isSecret = true
        viewController?.updateLockButton(memo.isSecret)
    }
}

// MARK: - UIPopoverPresentationControllerDelegate
extension DetailPresenter: UIPopoverPresentationControllerDelegate {

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
