//
//  PasswordAlertPresenter.swift
//  Memo
//
//  Created by 김민지 on 2022/04/29.
//  암호 입력 Alert 창 Presenter

import Foundation
import UIKit

protocol PasswordAlertProtocol: AnyObject {
    func setupView(_ isChecking: Bool)
    func applyFont()
    func dismiss()
    func updateMessageLabel(isEmpty: Bool)
}

final class PasswordAlertPresenter: NSObject {
    private let viewController: PasswordAlertProtocol?

    private var isChecking: Bool
    private var memo: Memo

    init(
        viewController: PasswordAlertProtocol?,
        isChecking: Bool,
        memo: Memo
    ) {
        self.viewController = viewController
        self.isChecking = isChecking
        self.memo = memo
    }

    func viewDidLoad() {
        viewController?.setupView(isChecking)
        viewController?.applyFont()
    }

    func didTappedCancelButton() {
        viewController?.dismiss()
    }

    func didTappedConfirmButton(_ password: String?) {
        guard let password = password else { return }

        if password.isEmpty {
            viewController?.updateMessageLabel(isEmpty: true)
        } else {
            if isChecking {
                if password == memo.password {
                    viewController?.dismiss()
                    NotificationCenter.default.post(name: NSNotification.Name("ShowMemo"), object: memo)
                } else {
                    viewController?.updateMessageLabel(isEmpty: false)
                }
            } else {
                viewController?.dismiss()
                NotificationCenter.default.post(name: NSNotification.Name("InputPassword"), object: password)
            }
        }
    }
}

// MARK: - UITextField
extension PasswordAlertPresenter: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        didTappedConfirmButton(textField.text)
        return true
    }
}
