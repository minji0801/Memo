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

    func popViewController()
    func keyboardHeightUp(_ keyboardHeight: CGFloat)
    func updateTextCount(_ count: Int)
}

final class WritePresenter: NSObject {
    private let viewController: WriteProtocol?

    init(viewController: WriteProtocol?) {
        self.viewController = viewController
    }

    func viewDidLoad() {
        viewController?.setupNavigationBar()
        viewController?.setupNoti()
        viewController?.setupView()
    }

    func didTappedLeftBarButton() {
        viewController?.popViewController()
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
