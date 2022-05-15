//
//  WritePresenter.swift
//  Memo
//
//  Created by 김민지 on 2022/04/29.
//  메모 작성(수정) 화면 presenter

import Foundation
import UIKit

protocol WriteProtocol: AnyObject {
    func setupNavigationBar()
    func setupNoti()
    func setupGesture()
    func setupView(_ isEditing: Bool, _ memo: Memo)
    func applyFont()

    func popToRootViewController()
    func showDismissAlertViewController()
    func showSaveAlertViewController()
    func showPasswordAlertViewController()

    func keyboardHeightUp(_ keyboardHeight: CGFloat)
    func updateTextCount(_ count: Int)
    func updateLockButton(_ isSecret: Bool)
    func updateTextView()
}

final class WritePresenter: NSObject {
    private let viewController: WriteProtocol?
    private let userDefaultsManager: UserDefaultsManagerProtol

    private var isEditing: Bool
    private var memo: Memo

    init(
        viewController: WriteProtocol?,
        userDefaultsManager: UserDefaultsManagerProtol = UserDefaultsManager(),
        isEditing: Bool,
        memo: Memo
    ) {
        self.viewController = viewController
        self.userDefaultsManager = userDefaultsManager
        self.isEditing = isEditing
        self.memo = memo
    }

    func viewDidLoad() {
        viewController?.setupNavigationBar()
        viewController?.setupNoti()
        viewController?.setupGesture()
        viewController?.setupView(isEditing, memo)
        viewController?.applyFont()
        viewController?.updateTextView()
    }

    func didTappedLeftBarButton(_ textCount: Int) {
        if textCount > 0 {
            viewController?.showDismissAlertViewController()
        } else {
            viewController?.popToRootViewController()
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

        if isEditing {
            id = memo.id
            newvalue = Memo(id: id, content: content, password: memo.password, isSecret: memo.isSecret)
            userDefaultsManager.editMemo(id, newvalue)
        } else {
            id = userDefaultsManager.getMemoId()
            newvalue = Memo(id: id, content: content, password: memo.password, isSecret: memo.isSecret)
            userDefaultsManager.setMemo(newvalue)
            userDefaultsManager.setMemoId()
        }

        viewController?.popToRootViewController()
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

    func willShowKeyBoard(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            viewController?.keyboardHeightUp(keyboardHeight)
        }
    }

    func inputPasswordNoti(_ notification: Notification) {
        guard let object = notification.object as? String else { return }

        memo.password = object
        memo.isSecret = true
        viewController?.updateLockButton(memo.isSecret)
    }
}

extension WritePresenter: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        viewController?.updateTextCount(textView.text.count)
        viewController?.updateTextView()
    }
}
