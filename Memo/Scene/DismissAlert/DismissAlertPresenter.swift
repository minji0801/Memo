//
//  DismissAlertPresenter.swift
//  Memo
//
//  Created by 김민지 on 2022/04/29.
//  메모 작성 취소 경고창 Presenter

import Foundation

protocol DismissAlertProtocol: AnyObject {
    func setupView()
    func applyFont()
    func dismiss()
    func postPopNoti()
}

final class DismissAlertPresenter: NSObject {
    private let viewController: DismissAlertProtocol?

    init(viewController: DismissAlertProtocol?) {
        self.viewController = viewController
    }

    func viewDidLoad() {
        viewController?.setupView()
        viewController?.applyFont()
    }

    func didTappedNoButton() {
        viewController?.dismiss()
    }

    func didTappedYesButton() {
        viewController?.postPopNoti()
        viewController?.dismiss()
    }
}
