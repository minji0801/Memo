//
//  DetailViewController.swift
//  Memo
//
//  Created by 김민지 on 2022/04/29.
//  메모 상세 화면

import Foundation
import SnapKit
import Toast
import UIKit

final class DetailViewController: UIViewController {
    private var presenter: DetailPresenter!

    init(memo: Memo) {
        super.init(nibName: nil, bundle: nil)
        presenter = DetailPresenter(viewController: self, memo: memo)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// 왼쪽 바 버튼: 뒤로가기 버튼
    private lazy var leftBarButton = UIBarButtonItem(
        image: UIImage(systemName: "arrow.left"),
        style: .plain,
        target: self,
        action: #selector(didTappedLeftBarButton)
    )

    /// 오른쪽 바 버튼: 삭제 버튼
    private lazy var menuRightBarButton = UIBarButtonItem(
        image: UIImage(systemName: "trash"),
        style: .plain,
        target: self,
        action: #selector(didTappedMenuRightBarButton)
    )

    /// 오른쪽 바 버튼: 잠금 버튼
    private lazy var lockRightBarButton = UIBarButtonItem(
        image: UIImage(systemName: "lock"),
        style: .plain,
        target: self,
        action: #selector(didTappedLockRightBarButton)
    )

    /// 메모 내용 텍스트 뷰
    private lazy var textView: UITextView = {
        let textView = UITextView()

        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.viewDidLoad()
    }
}

extension DetailViewController: DetailProtocol {
    /// 네비게이션 바 구성
    func setupNavigationBar() {
        navigationItem.title = "메모 내용"
        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.rightBarButtonItems = [menuRightBarButton, lockRightBarButton]
    }

    /// 노티 구성
    func setupNoti() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(deleteMemoNoti(_:)),
            name: NSNotification.Name("DeleteMemo"),
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(inputPasswordNoti),
            name: NSNotification.Name("InputPassword"),
            object: nil
        )
    }

    /// 제스처 등록
    func setupGesture() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(didTappedLeftBarButton))
        view.addGestureRecognizer(swipeLeft)
    }

    /// 뷰 구성
    func setupView(_ memo: Memo) {
        view.backgroundColor = .systemBackground

        if memo.isSecret {
            lockRightBarButton.image = UIImage(systemName: "lock.fill")
        } else {
            lockRightBarButton.image = UIImage(systemName: "lock")
        }

        textView.text = memo.content

        view.addSubview(textView)

        let spacing: CGFloat = 16.0

        textView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(spacing)
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide).inset(spacing)
        }
    }

    /// 폰트 적용
    func applyFont() {
        let font = FontManager.getFont()

        textView.font = font.largeFont
    }

    /// 현재 뷰 pop
    func popViewController() {
        navigationController?.popViewController(animated: true)
    }

    /// 메모 삭제 Alert 보여주기
    func showDeleteAlertViewController() {
        let deleteAlertViewController = DeleteAlertViewController()
        deleteAlertViewController.modalPresentationStyle = .overCurrentContext
        present(deleteAlertViewController, animated: false)
    }

    /// 암호 입력 Alert 보여주기
    func showPasswordAlertViewController() {
        let passwordAlertViewController = PasswordAlertViewController(isChecking: false, memo: Memo.EMPTY)
        passwordAlertViewController.modalPresentationStyle = .overCurrentContext
        present(passwordAlertViewController, animated: false)
    }

    /// 자물쇠 버튼 업데이트
    func updateLockButton(_ isSecret: Bool) {
        if isSecret {
            lockRightBarButton.image = UIImage(systemName: "lock.fill")
        } else {
            lockRightBarButton.image = UIImage(systemName: "lock")
        }
    }
}

// MARK: - @objc Function
extension DetailViewController {
    /// 뒤로 가기 버튼 클릭 -> pop
    @objc func didTappedLeftBarButton() {
        presenter.didTappedLeftBarButton(textView.text)
    }

    /// 삭제 버튼 클릭 ->  삭제 Alert 띄우기
    @objc func didTappedMenuRightBarButton(_ sender: UIBarButtonItem) {
        presenter.didTappedMenuRightBarButton(sender)
    }

    /// 자물쇠 버튼 클릭 -> 현재 상태 Toast 알림으로 띄워주기
    @objc func didTappedLockRightBarButton() {
        presenter.didTappedLockRightBarButton()
    }

    /// 메모 삭제하라는 노티 -> 메모 삭제
    @objc func deleteMemoNoti(_ notification: Notification) {
        presenter.deleteMemoNoti()
    }

    /// 암호 입력했다는 노티
    @objc func inputPasswordNoti(_ notification: Notification) {
        presenter.inputPasswordNoti(notification)
    }
}
