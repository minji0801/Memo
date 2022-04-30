//
//  PasswordAlertPresenter.swift
//  Memo
//
//  Created by 김민지 on 2022/04/29.
//  암호 입력 Alert 창 Presenter

import Foundation
import UIKit

protocol PasswordAlertProtocol: AnyObject {
    func setupView()
    func applyFont()
    func dismiss()
    func updateMessageLabel()
}

final class PasswordAlertPresenter: NSObject {
    private let viewController: PasswordAlertProtocol?

    init(viewController: PasswordAlertProtocol?) {
        self.viewController = viewController
    }

    func viewDidLoad() {
        viewController?.setupView()
        viewController?.applyFont()
    }

    func didTappedCancelButton() {
        viewController?.dismiss()
    }

    func didTappedConfirmButton(_ password: String?) {
        guard let password = password else { return }

        if password.isEmpty {
            viewController?.updateMessageLabel()
        } else {
            viewController?.dismiss()
            NotificationCenter.default.post(name: NSNotification.Name("InputPassword"), object: password)
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
