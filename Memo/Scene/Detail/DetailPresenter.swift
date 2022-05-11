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
    func setupView()
    func setupMemo(_ memo: Memo)

    func popViewController()
    func showDeleteAlertViewController()
    func showSaveAlertViewController()
    func showPasswordAlertViewController()

    func updateLockButton(_ isSecret: Bool)
    func updateTextCount(_ count: Int)
    func updateTextView()
    func changeStatus(isEditing: Bool)
    func keyboardUpOrDown(_ keyboardHeight: CGFloat, isUp: Bool)
}

final class DetailPresenter: NSObject {
    private let viewController: DetailProtocol?
    private let userDefaultsManager: UserDefaultsManagerProtol

    private var memo: Memo

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
        viewController?.setupView()
    }

    func viewWillAppear() {
        viewController?.setupMemo(memo)
        viewController?.updateTextView()
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

    func didTappedDeleteRightBarButton(_ sender: UIBarButtonItem) {
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

    func didTappedSaveRightBarButton(_ content: String?) {
        guard let content = content else { return }

        if content.isEmpty {
            viewController?.showSaveAlertViewController()
            return
        }

        var id: Int
        var newvalue: Memo

        id = memo.id
        newvalue = Memo(id: id, content: content, password: memo.password, isSecret: memo.isSecret)
        userDefaultsManager.editMemo(id, newvalue)

        viewController?.changeStatus(isEditing: false)
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

    func willShowKeyBoard(_ notification: Notification, isUp: Bool) {
        // 키보드 높이에 따라 뷰 조정하기
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            viewController?.keyboardUpOrDown(keyboardHeight, isUp: isUp)
        }

        // 수정 모드로 변환하기
        if isUp { viewController?.changeStatus(isEditing: true) }
    }
}

// MARK: - UITextViewDelegate
extension DetailPresenter: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        viewController?.updateTextCount(textView.text.count)
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
