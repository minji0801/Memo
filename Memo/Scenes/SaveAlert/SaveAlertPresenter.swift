//
//  SaveAlertPresenter.swift
//  Memo
//
//  Created by 김민지 on 2022/04/29.
//  작성한 메모 내용이 없을 때 보여주는 화면 Presenter

import Foundation

protocol SaveAlertProtocol: AnyObject {
    func setupView()
    func dismiss()
}

final class SaveAlertPresenter: NSObject {
    private let viewController: SaveAlertProtocol?

    init(viewController: SaveAlertProtocol?) {
        self.viewController = viewController
    }

    func viewDidLoad() {
        viewController?.setupView()
    }

    func didTappedConfirmButton() {
        viewController?.dismiss()
    }
}
