//
//  ListViewController.swift
//  Memo
//
//  Created by 김민지 on 2022/04/29.
//  메모 목록 화면

import SnapKit
import UIKit

final class ListViewController: UIViewController {
    private lazy var presenter = ListPresenter(viewController: self)
    private let font = FontManager.getFont()

    /// 오른쪽 바 버튼: 메모 작성 버튼
    private lazy var rightBarButton = UIBarButtonItem(
        image: UIImage(systemName: "square.and.pencil"),
        style: .plain,
        target: self,
        action: #selector(didTappedRightBarButton)
    )

    /// 검색 바
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "메모 검색"
        searchBar.searchTextField.font = font.largeFont
        searchBar.searchBarStyle = .minimal

        searchBar.delegate = presenter

        return searchBar
    }()

    /// 테이블 뷰
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = presenter
        tableView.delegate = presenter

        tableView.register(
            ListTableViewCell.self,
            forCellReuseIdentifier: ListTableViewCell.identifier
        )

        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.viewDidLoad()
        // 폰트 체크 하기
//        UIFont.familyNames.sorted().forEach { familyName in
//            print("*** \(familyName) ***")
//            UIFont.fontNames(forFamilyName: familyName).forEach { fontName in
//                print("\(fontName)")
//            }
//            print("---------------------")
//        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        presenter.viewWillAppear()
    }
}

// MARK: - ListProtocol Function
extension ListViewController: ListProtocol {
    /// 네비게이션 바 구성
    func setupNavigationBar() {
        navigationItem.title = "메모 목록"
        navigationItem.rightBarButtonItem = rightBarButton

        let font = FontManager.getFont()
        navigationController?.navigationBar.titleTextAttributes = [
            .font: font.extraLargeFont
        ]
    }

    /// 노티 구성
    func setupNoti() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(showMemoNoti(_:)),
            name: NSNotification.Name("ShowMemo"),
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(deleteMemoNoti(_:)),
            name: NSNotification.Name("DeleteMemo"),
            object: nil
        )
    }

    /// 뷰 구성
    func setupView() {
        view.backgroundColor = .systemBackground

        [searchBar, tableView].forEach {
            view.addSubview($0)
        }

        searchBar.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(10.0)
            $0.top.equalTo(view.safeAreaLayoutGuide)
        }

        tableView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(searchBar.snp.bottom)
        }
    }

    /// 키보드 내리기
    func keyboardDown() {
        view.endEditing(true)
    }

    /// 테이블 뷰 다시 로드하기
    func reloadTableView() {
        tableView.reloadData()
    }

    /// 메모 작성 화면 보여주기
    func pushToWriteViewController() {
        let writeViewController = WriteViewController(isEditing: false, memo: Memo.EMPTY)
        navigationController?.pushViewController(writeViewController, animated: true)
    }

    /// 메모 상세 화면 보여주기
    func pushToDetailViewController(_ memo: Memo) {
        let detailViewController = DetailViewController(memo: memo)
        navigationController?.pushViewController(detailViewController, animated: true)
    }

    /// 암호 입력 Alert 창 보여주기
    func showPasswordAlertViewController(_ memo: Memo) {
        let passwordAlertViewController = PasswordAlertViewController(isChecking: true, memo: memo)
        passwordAlertViewController.modalPresentationStyle = .overCurrentContext
        present(passwordAlertViewController, animated: false)
    }

    /// 메모 삭제 Alert 창 보여주기
    func showDeleteAlertViewController() {
        let deleteAlertViewController = DeleteAlertViewController()
        deleteAlertViewController.modalPresentationStyle = .overCurrentContext
        present(deleteAlertViewController, animated: false)
    }
}

// MARK: - @objc Function
extension ListViewController {
    /// 메모 작성 버튼 클릭 -> 작성 화면으로 이동하기
    @objc func didTappedRightBarButton() {
        presenter.didTappedRightBarButton()
    }

    /// 메모 보여주라는 노티 -> 클릭한 메모 보여주기
    @objc func showMemoNoti(_ notification: Notification) {
        presenter.showMemoNoti(notification)
    }

    /// 메모 삭제하라는 노티 -> 메모 삭제
    @objc func deleteMemoNoti(_ notification: Notification) {
        presenter.deleteMemoNoti()
    }
}
