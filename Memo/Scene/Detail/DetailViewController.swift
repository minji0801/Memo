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

    /// 오른쪽 바 버튼: 메뉴 버튼
    private lazy var menuRightBarButton = UIBarButtonItem(
        image: UIImage(systemName: "ellipsis"),
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
        textView.isEditable = false

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
            selector: #selector(didTappedEditNoti(_:)),
            name: NSNotification.Name("DidTappedEdit"),
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didTappedDeleteNoti(_:)),
            name: NSNotification.Name("DidTappedDelete"),
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(deleteMemoNoti(_:)),
            name: NSNotification.Name("DeleteMemo"),
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

    /// 팝업 메뉴 보여주기
    func showDetailPopupViewController(_ popoverContentController: DetailPopupViewController) {
        present(popoverContentController, animated: true, completion: nil)
    }

    /// 메모 수정 화면 push
    func pushToWriteViewController() {
        let writeViewController = WriteViewController(isEditing: true, memo: presenter.memo)
        navigationController?.pushViewController(writeViewController, animated: true)
    }

    /// 메모 삭제 Alert 보여주기
    func showDeleteAlertViewController() {
        let deleteAlertViewController = DeleteAlertViewController()
        deleteAlertViewController.modalPresentationStyle = .overCurrentContext
        present(deleteAlertViewController, animated: false)
    }

    func showToast(_ isSecret: Bool) {
        var style = ToastStyle()
        style.messageAlignment = .center
        style.messageFont = FontManager.getFont().largeFont
        style.messageColor = .systemBackground
        style.backgroundColor = .label

        if isSecret {
            view.makeToast("수정 화면에서 일반 메모로 변경하실 수 있습니다.", style: style)
        } else {
            view.makeToast("수정 화면에서 비밀 메모로 변경하실 수 있습니다.", style: style)
        }
    }
}

// MARK: - @objc Function
extension DetailViewController {
    /// 뒤로 가기 버튼 클릭 -> pop
    @objc func didTappedLeftBarButton() {
        presenter.didTappedLeftBarButton()
    }

    /// 메뉴 버튼 클릭 -> 메뉴(수정, 삭제) 보여주기
    @objc func didTappedMenuRightBarButton(_ sender: UIBarButtonItem) {
        presenter.didTappedMenuRightBarButton(sender)
    }

    /// 자물쇠 버튼 클릭 -> 현재 상태 Toast 알림으로 띄워주기
    @objc func didTappedLockRightBarButton() {
        presenter.didTappedLockRightBarButton()
    }

    /// 팝업에서 수정 버튼 눌렀다는 노티 -> 수정(작성) 화면으로 이동
    @objc func didTappedEditNoti(_ notification: Notification) {
        presenter.didTappedEditNoti()
    }

    /// 팝업에서 삭제 버튼 눌렀다는 노티 -> 삭제 Alert 창 보여주기
    @objc func didTappedDeleteNoti(_ notification: Notification) {
        presenter.didTappedDeleteNoti()
    }

    /// 메모 삭제하라는 노티 -> 메모 삭제
    @objc func deleteMemoNoti(_ notification: Notification) {
        presenter.deleteMemoNoti()
    }
}
