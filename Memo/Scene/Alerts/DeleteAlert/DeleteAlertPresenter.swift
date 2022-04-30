//
//  DeleteAlertPresenter.swift
//  Memo
//
//  Created by 김민지 on 2022/04/30.
//  메모 삭제 화면 Presenter

import Foundation

protocol DeleteAlertProtocol: AnyObject {
    func setupView()
    func applyFont()
    func dismiss()
}

final class DeleteAlertPresenter: NSObject {
    private let viewController: DeleteAlertProtocol?

    init(viewController: DeleteAlertProtocol?) {
        self.viewController = viewController
    }

    func viewDidLoad() {
        viewController?.setupView()
        viewController?.applyFont()
    }

    func didTappedCancelButton() {
        viewController?.dismiss()
    }

    func didTappedDeleteButton() {
        viewController?.dismiss()
        NotificationCenter.default.post(name: NSNotification.Name("DeleteMemo"), object: nil)
    }
}
