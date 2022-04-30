//
//  DetailPopupPresenter.swift
//  Memo
//
//  Created by 김민지 on 2022/04/29.
//  메모 상세 화면 팝업 메뉴 Presenter

import Foundation

protocol DetailPopupProtocol: AnyObject {
    func setupView()
    func applyFont()
    func dismiss()
}

final class DetailPopupPresenter: NSObject {
    private let viewController: DetailPopupProtocol?

    init(viewController: DetailPopupProtocol?) {
        self.viewController = viewController
    }

    func viewDidLoad() {
        viewController?.setupView()
        viewController?.applyFont()
    }

    func didTappedEditButton() {
        NotificationCenter.default.post(name: NSNotification.Name("DidTappedEdit"), object: nil)
        viewController?.dismiss()
    }

    func didTappedDeleteButton() {
        NotificationCenter.default.post(name: NSNotification.Name("DidTappedDelete"), object: nil)
        viewController?.dismiss()
    }
}
