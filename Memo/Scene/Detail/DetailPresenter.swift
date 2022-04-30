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
    func showDetailPopupViewController(_ popoverContentController: DetailPopupViewController)
    func pushToWriteViewController()
    func showDeleteAlertViewController()
    func showToast(_ isSecret: Bool)
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

    func didTappedLeftBarButton() {
        viewController?.popViewController()
    }

    func didTappedMenuRightBarButton(_ sender: UIBarButtonItem) {
        let popoverContentController = DetailPopupViewController()
        popoverContentController.modalPresentationStyle = .popover
        popoverContentController.preferredContentSize = CGSize(width: 80, height: 100)

        if let popoverPresentationController = popoverContentController.popoverPresentationController {
            popoverPresentationController.permittedArrowDirections = .right
            popoverPresentationController.barButtonItem = sender
            popoverPresentationController.delegate = self
            viewController?.showDetailPopupViewController(popoverContentController)
        }
    }

    func didTappedLockRightBarButton() {
        viewController?.showToast(memo.isSecret)
    }

    func didTappedEditNoti() {
        viewController?.pushToWriteViewController()
    }

    func didTappedDeleteNoti() {
        viewController?.showDeleteAlertViewController()
    }

    func deleteMemoNoti() {
        let id = memo.id
        userDefaultsManager.deleteMemo(id)
        viewController?.popViewController()
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
