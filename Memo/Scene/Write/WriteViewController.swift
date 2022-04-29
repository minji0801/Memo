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
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(spacing)
            $0.bottom.equalTo(countLabel.snp.top)
        }

        countLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(spacing)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    /// 폰트 적용
    func applyFont() {
        let font = FontManager.getFont()

        textView.font = font.largeFont
        countLabel.font = font.mediumFont
    }

    /// 현재 뷰 pop
    func popViewController() {
        navigationController?.popViewController(animated: true)
    }

    /// root 뷰로 pop
    func popToRootViewController() {
        navigationController?.popToRootViewController(animated: true)
    }

    /// 내용이 있을 때 정말 닫을 건지 Alert 창 보여주기
    func showDismissAlertViewController() {
        let dismissAlertViewController = DismissAlertViewController()
        dismissAlertViewController.modalPresentationStyle = .overCurrentContext
        present(dismissAlertViewController, animated: false)
    }

    /// 내용을 작성하고 저장해달라는 Alert 창 보여주기
    func showSaveAlertViewController() {
        let saveAlertViewController = SaveAlertViewController()
        saveAlertViewController.modalPresentationStyle = .overCurrentContext
        present(saveAlertViewController, animated: false)
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
    /// 뒤로 가기 버튼 클릭 -> pop
    @objc func didTappedLeftBarButton() {
        presenter.didTappedLeftBarButton(textView.text.count)
    }

    /// 체크 버튼 클릭 -> 저장하기
    @objc func didTappedRightBarButton() {
        presenter.didTappedRightBarButton(textView.text)
    }

    /// 키보드 보여질 때 받는 노티
    @objc func willShowKeyBoard(_ notification: Notification) {
        presenter.willShowKeyBoard(notification)
    }

    /// 현재 뷰 pop하라는 노티
    @objc func popViewNoti() {
        textView.text = ""
        presenter.didTappedLeftBarButton(textView.text.count)
    }
}
