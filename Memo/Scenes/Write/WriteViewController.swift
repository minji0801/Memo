//
//  WriteViewController.swift
//  Memo
//
//  Created by 김민지 on 2022/04/29.
//  메모 작성(수정) 화면

import Foundation
import SnapKit
import UIKit

final class WriteViewController: UIViewController {
    private lazy var presenter = WritePresenter(viewController: self)

    /// 왼쪽 바 버튼: 뒤로가기 버튼
    private lazy var leftBarButton = UIBarButtonItem(
        image: UIImage(systemName: "arrow.left"),
        style: .plain,
        target: self,
        action: #selector(didTappedLeftBarButton)
    )

    /// 오른쪽 바 버튼: 작성 완료 버튼
    private lazy var rightBarButton = UIBarButtonItem(
        image: UIImage(systemName: "checkmark"),
        style: .plain,
        target: self,
        action: #selector(didTappedRightBarButton)
    )

    /// 메모 작성 뷰
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 17.0)
        textView.delegate = presenter
        textView.becomeFirstResponder()

        return textView
    }()

    /// 글자 수 라벨
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textAlignment = .right

        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.viewDidLoad()
    }
}

// MARK: - ListProtocol Function
extension WriteViewController: WriteProtocol {
    /// 네비게이션 바 구성
    func setupNavigationBar() {
        navigationItem.title = "메모 작성"
        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.rightBarButtonItem = rightBarButton
    }

    func setupNoti() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(willShowKeyBoard(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(popViewNoti),
            name: NSNotification.Name("PopWriteViewController"),
            object: nil
        )
    }

    /// 뷰 구성
    func setupView() {
        view.backgroundColor = .systemBackground

        [textView, countLabel].forEach {
            view.addSubview($0)
        }

        let spacing: CGFloat = 16.0

        textView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(spacing)
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(countLabel.snp.top)
        }

        countLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(spacing)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    /// 현재 뷰 pop
    func popViewController() {
        if textView.text.count > 0 {
            let dismissAlertViewController = DismissAlertViewController()
            dismissAlertViewController.modalPresentationStyle = .overCurrentContext
            present(dismissAlertViewController, animated: false)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }

    /// 키보드 높이만큼 올리기
    func keyboardHeightUp(_ keyboardHeight: CGFloat) {
        UIView.animate(withDuration: 1) {
            self.countLabel.snp.makeConstraints {
                $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(keyboardHeight)
            }
        }
    }

    /// 글자 수 업데이트
    func updateTextCount(_ count: Int) {
        countLabel.text = "\(count)"
    }
}

// MARK: - @objc Function
extension WriteViewController {
    @objc func didTappedLeftBarButton() {
        presenter.didTappedLeftBarButton()
    }

    @objc func didTappedRightBarButton() {}

    @objc func willShowKeyBoard(_ notification: Notification) {
        presenter.willShowKeyBoard(notification)
    }

    @objc func popViewNoti() {
        textView.text = ""
        presenter.didTappedLeftBarButton()
    }
}
