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
    func setupView()
    func applyFont()

    func popViewController()
    func popToRootViewController()
    func showDismissAlertViewController()
    func showSaveAlertViewController()
    func showPasswordAlertViewController()

    func keyboardHeightUp(_ keyboardHeight: CGFloat)
    func updateTextCount(_ count: Int)
    func updateLockButton(_ isSecret: Bool)
}

final class WritePresenter: NSObject {
    private let viewController: WriteProtocol?
    private let userDefaultsManager: UserDefaultsManagerProtol

    private var password: String = ""
    private var isSecret: Bool = false

    init(
        viewController: WriteProtocol?,
        userDefaultsManager: UserDefaultsManagerProtol = UserDefaultsManager()
    ) {
        self.viewController = viewController
        self.userDefaultsManager = userDefaultsManager
    }

    func viewDidLoad() {
        viewController?.setupNavigationBar()
        viewController?.setupNoti()
        viewController?.setupView()
        viewController?.applyFont()
    }

    func viewWillAppear() {
        print("비밀메모인가?", isSecret, "암호 :", password)
    }

    func didTappedLeftBarButton(_ textCount: Int) {
        if textCount > 0 {
            viewController?.showDismissAlertViewController()
        } else {
            viewController?.popViewController()
        }
    }

    func didTappedSaveRightBarButton(_ content: String?) {
        guard let content = content else { return }

        if content.isEmpty {
            viewController?.showSaveAlertViewController()
        } else {
            let id = userDefaultsManager.getMemoId()
            let memo: Memo = Memo(id: id, content: content, password: password, isSecret: isSecret)
            userDefaultsManager.setMemo(memo)
            viewController?.popToRootViewController()
        }
    }

    func didTappedLockRightBarButton() {
        if isSecret {
            // 이미 비밀 메모로 설정했으니까 일반 메모로 바꾸기
            isSecret = false
            password = ""
            viewController?.updateLockButton(isSecret)
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

        password = object
        isSecret = true
        viewController?.updateLockButton(isSecret)
    }
}

extension WritePresenter: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        viewController?.updateTextCount(textView.text.count)
    }
}
