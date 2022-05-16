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
    private var presenter: WritePresenter!

    init(isEditing: Bool, memo: Memo) {
        super.init(nibName: nil, bundle: nil)
        presenter = WritePresenter(viewController: self, isEditing: isEditing, memo: memo)
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

    /// 오른쪽 바 버튼: 작성 완료 버튼
    private lazy var saveRightBarButton = UIBarButtonItem(
        image: UIImage(systemName: "checkmark"),
        style: .plain,
        target: self,
        action: #selector(didTappedSaveRightBarButton)
    )

    /// 오른쪽 바 버튼: 잠금 버튼
    private lazy var lockRightBarButton = UIBarButtonItem(
        image: UIImage(systemName: "lock"),
        style: .plain,
        target: self,
        action: #selector(didTappedLockRightBarButton)
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
        navigationItem.rightBarButtonItems = [saveRightBarButton, lockRightBarButton]
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
            name: NSNotification.Name("PopViewController"),
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
    func setupView(_ isEditing: Bool, _ memo: Memo) {
        view.backgroundColor = .systemBackground

        if isEditing {
            textView.text = memo.content
            countLabel.text = "글자수 : \(memo.content.count)"
            updateLockButton(memo.isSecret)
        }

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

    /// 암호 입력 Alert 보여주기
    func showPasswordAlertViewController() {
        let passwordAlertViewController = PasswordAlertViewController(isChecking: false, memo: Memo.EMPTY)
        passwordAlertViewController.modalPresentationStyle = .overCurrentContext
        present(passwordAlertViewController, animated: false)
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
        countLabel.text = "글자수 : \(count)"
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
extension WriteViewController {
    /// 뒤로 가기 버튼 클릭 -> pop
    @objc func didTappedLeftBarButton() {
        presenter.didTappedLeftBarButton(textView.text.count)
    }

    /// 체크 버튼 클릭 -> 저장하기
    @objc func didTappedSaveRightBarButton() {
        presenter.didTappedSaveRightBarButton(textView.text)
    }

    /// 자물쇠 버튼 클릭 -> 비밀 메모 설정
    @objc func didTappedLockRightBarButton() {
        presenter.didTappedLockRightBarButton()
    }

    /// 키보드 보여질 때 받는 노티
    @objc func willShowKeyBoard(_ notification: Notification) {
        presenter.willShowKeyBoard(notification)
    }

    /// 현재 뷰 pop하라는 노티
    @objc func popViewNoti(_ notification: Notification) {
        textView.text = ""
        presenter.didTappedLeftBarButton(textView.text.count)
    }

    /// 암호 입력했다는 노티
    @objc func inputPasswordNoti(_ notification: Notification) {
        presenter.inputPasswordNoti(notification)
    }
}
