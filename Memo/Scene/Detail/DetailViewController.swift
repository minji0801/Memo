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
    private let font = FontManager.getFont()

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
    private lazy var deleteRightBarButton = UIBarButtonItem(
        image: UIImage(systemName: "trash"),
        style: .plain,
        target: self,
        action: #selector(didTappedDeleteRightBarButton)
    )

    /// 오른쪽 바 버튼: 잠금 버튼
    private lazy var lockRightBarButton = UIBarButtonItem(
        image: UIImage(systemName: "lock"),
        style: .plain,
        target: self,
        action: #selector(didTappedLockRightBarButton)
    )

    /// 오른쪽 바 버튼: 작성 완료 버튼
    private lazy var saveRightBarButton = UIBarButtonItem(
        image: UIImage(systemName: "checkmark"),
        style: .plain,
        target: self,
        action: #selector(didTappedSaveRightBarButton)
    )

    /// 메모 내용 텍스트 뷰
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.delegate = presenter

        return textView
    }()

    /// 글자 수 라벨
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textAlignment = .right
        label.font = font.mediumFont

        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        presenter.viewWillAppear()
    }
}

extension DetailViewController: DetailProtocol {
    /// 네비게이션 바 구성
    func setupNavigationBar() {
        navigationItem.title = "메모 내용"
        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.rightBarButtonItems = [deleteRightBarButton, lockRightBarButton]
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
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(willShowKeyBoard(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(willHideKeyBoard(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    /// 제스처 등록
    func setupGesture() {
        let swipeLeft = UISwipeGestureRecognizer(
            target: self,
            action: #selector(didTappedLeftBarButton)
        )
        view.addGestureRecognizer(swipeLeft)
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
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(spacing)
            $0.height.equalTo(30.0)
        }
    }

    /// 메모 구성
    func setupMemo(_ memo: Memo) {
        if memo.isSecret {
            lockRightBarButton.image = UIImage(systemName: "lock.fill")
        } else {
            lockRightBarButton.image = UIImage(systemName: "lock")
        }

        textView.text = memo.content
        countLabel.text = "글자수 : \(memo.content.count)"
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

    /// 내용을 작성하고 저장해달라는 Alert 창 보여주기
    func showSaveAlertViewController() {
        let saveAlertViewController = SaveAlertViewController()
        saveAlertViewController.modalPresentationStyle = .overCurrentContext
        present(saveAlertViewController, animated: false)
    }

    /// 자물쇠 버튼 업데이트
    func updateLockButton(_ isSecret: Bool) {
        if isSecret {
            lockRightBarButton.image = UIImage(systemName: "lock.fill")
        } else {
            lockRightBarButton.image = UIImage(systemName: "lock")
        }
    }

    /// 글자 수 업데이트
    func updateTextCount(_ count: Int) {
        countLabel.text = "글자수 : \(count)"
    }

    /// TextView 스타일 업데이트
    func updateTextView() {
        let attrString = NSMutableAttributedString(string: textView.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10

        attrString.addAttribute(
            NSAttributedString.Key.paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0, length: attrString.length)
        )
        textView.attributedText = attrString
        textView.font = font.largeFont
        textView.textColor = .label
    }

    /// 화면 전환(내용 - 수정)
    func changeStatus(isEditing: Bool) {
        if isEditing {
            navigationItem.rightBarButtonItem = saveRightBarButton
            // TODO: 왼쪽은 되돌리기버튼
        } else {
            navigationItem.rightBarButtonItems = [deleteRightBarButton, lockRightBarButton]
            view.endEditing(true)
        }
    }

    /// 키보드 높이만큼 올리거나 내리기
    func keyboardUpOrDown(_ keyboardHeight: CGFloat, isUp: Bool) {
        UIView.animate(withDuration: 1) {
            if isUp {
                self.view.frame.size.height -= keyboardHeight
            } else {
                self.view.frame.size.height += keyboardHeight
            }
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
    @objc func didTappedDeleteRightBarButton(_ sender: UIBarButtonItem) {
        presenter.didTappedDeleteRightBarButton(sender)
    }

    /// 체크 버튼 클릭 -> 저장하기
    @objc func didTappedSaveRightBarButton() {
        presenter.didTappedSaveRightBarButton(textView.text)
    }

    /// 자물쇠 버튼 클릭 -> 일반-비밀 메모 변경하기
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

    /// 키보드 올라올 때 받는 노티
    @objc func willShowKeyBoard(_ notification: Notification) {
        presenter.willShowKeyBoard(notification, isUp: true)
    }

    /// 키보드 내려갈 때 받는 노티
    @objc func willHideKeyBoard(_ notification: Notification) {
        presenter.willShowKeyBoard(notification, isUp: false)
    }
}
