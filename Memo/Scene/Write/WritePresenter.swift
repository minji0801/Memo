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
    func keyboardHeightUp(_ keyboardHeight: CGFloat)
    func updateTextCount(_ count: Int)
}

final class WritePresenter: NSObject {
    private let viewController: WriteProtocol?
    private let userDefaultsManager: UserDefaultsManagerProtol

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

    func didTappedLeftBarButton(_ textCount: Int) {
        if textCount > 0 {
            viewController?.showDismissAlertViewController()
        } else {
            viewController?.popViewController()
        }
    }

    func didTappedRightBarButton(_ content: String?) {
        guard let content = content else { return }
        let textCount = content.count
        let id = userDefaultsManager.getMemoId()

        if textCount > 0 {
            let memo: Memo = Memo(id: id, content: content, isSecret: false)
            userDefaultsManager.setMemo(memo)
            viewController?.popToRootViewController()
        } else {
            viewController?.showSaveAlertViewController()
        }
    }

    func willShowKeyBoard(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            viewController?.keyboardHeightUp(keyboardHeight)
        }
    }
}

extension WritePresenter: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        viewController?.updateTextCount(textView.text.count)
    }
}
