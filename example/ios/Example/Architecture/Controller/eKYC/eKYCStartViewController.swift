/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

import UIKit

enum eKYCSelectTypeItem {
    case empty(height: CGFloat)
    case all
    case verify
    case faceCompare
    case faceDomainError
}

final class eKYCStartViewController: UIViewController {

    private var items: [eKYCSelectTypeItem] {
        if Service.hasFaceDomainInfo {
            return [.empty(height: 24), .all, .empty(height: 21), .verify,
                    .empty(height: 21), .faceCompare, .empty(height: 24)]
        } else {
            return [.empty(height: 24), .all, .faceDomainError, .empty(height: 15), .verify,
                    .empty(height: 21), .faceCompare, .faceDomainError, .empty(height: 24)]
        }
    }

    private var normalTableHeight: [NSLayoutConstraint] = []
    private var errorTableHeight: [NSLayoutConstraint] = []

    private lazy var headerView: NavigationHeaderView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.set(rightButtonImage: AssetImage.icon_setting.uiImage)
        $0.tapBack = { [weak self] in self?.navigationController?.popViewController(animated: true) }
        $0.tapRightButton = { [weak self] in self?.showSetting() }
        return $0
    }(NavigationHeaderView())

    private lazy var startButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = AssetColor.clovaGreen.uiColor
        $0.setTitle("Let's Start", for: .normal)
        $0.tintColor = .white
        $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        $0.makeRoundBorder(radius: 3)
        $0.addTarget(self, action: #selector(tapStartButton))
        return $0
    }(UIButton())

    private let scrollView: UIScrollView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .clear
        return $0
    }(UIScrollView())

    private let contentView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .clear
        return $0
    }(UIView())

    private let titleLabel1: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 23, weight: 700)
        $0.textAlignment = .center
        $0.text = "Choose a mode"
        $0.adjustsFontSizeToFitWidth = true
        return $0
    }(UILabel())

    private let titleLabel2: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 23, weight: 700)
        $0.textAlignment = .center
        $0.text = "before you start the"
        $0.adjustsFontSizeToFitWidth = true
        return $0
    }(UILabel())

    private let titleLabel3: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = AssetColor.clovaGreen.uiColor
        $0.font = .systemFont(ofSize: 23, weight: 700)
        $0.textAlignment = .center
        $0.text = "eKYC Scenario"
        $0.adjustsFontSizeToFitWidth = true
        return $0
    }(UILabel())

    private let tableBaseView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = AssetColor.clovaBlack.uiColor?.withAlphaComponent(0.7)
        $0.makeRoundBorder(radius: 3)
        return $0
    }(UIView())

    private lazy var tableView: UITableView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.clipsToBounds = true
        $0.backgroundColor = .clear
        $0.allowsMultipleSelection = false
        $0.allowsSelection = true
        $0.separatorStyle = .none
        $0.isScrollEnabled = false
        $0.delegate = self
        $0.dataSource = self
        $0.register(RadioButtonTableViewCell_A.self)
        $0.register(ErrorTableViewCell.self)
        $0.register(EmptyTableViewCell.self)
        return $0
    }(UITableView())
}

extension eKYCStartViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.isScrollEnabled = (scrollView.frame.height < scrollView.contentSize.height)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateFaceDomainInfo()
        tableView.reloadData()
    }
}

extension eKYCStartViewController {

    private func configureLayout() {
        view.backgroundColor = .black
        view.addSubview(headerView)
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            headerView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])

        view.addSubview(startButton)
        NSLayoutConstraint.activate([
            startButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -34),
            startButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 34),
            startButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -34),
            startButton.heightAnchor.constraint(equalToConstant: 54)
        ])

        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            scrollView.bottomAnchor.constraint(equalTo: startButton.topAnchor, constant: -34),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])

        scrollView.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.leftAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leftAnchor),
            contentView.rightAnchor.constraint(equalTo: scrollView.contentLayoutGuide.rightAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 316)
        ])

        contentView.addSubview(titleLabel1)
        NSLayoutConstraint.activate([
            titleLabel1.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 27),
            titleLabel1.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 34),
            titleLabel1.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -34),
            titleLabel1.heightAnchor.constraint(equalToConstant: 29)
        ])

        contentView.addSubview(titleLabel2)
        NSLayoutConstraint.activate([
            titleLabel2.topAnchor.constraint(equalTo: titleLabel1.bottomAnchor),
            titleLabel2.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 34),
            titleLabel2.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -34),
            titleLabel2.heightAnchor.constraint(equalToConstant: 29)
        ])

        contentView.addSubview(titleLabel3)
        NSLayoutConstraint.activate([
            titleLabel3.topAnchor.constraint(equalTo: titleLabel2.bottomAnchor),
            titleLabel3.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 34),
            titleLabel3.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -34),
            titleLabel3.heightAnchor.constraint(equalToConstant: 29)
        ])

        contentView.addSubview(tableBaseView)
        NSLayoutConstraint.activate([
            tableBaseView.topAnchor.constraint(equalTo: titleLabel3.bottomAnchor, constant: 34),
            tableBaseView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 34),
            tableBaseView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -34)
        ])

        tableBaseView.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: tableBaseView.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: tableBaseView.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: tableBaseView.leftAnchor, constant: 32),
            tableView.rightAnchor.constraint(equalTo: tableBaseView.rightAnchor, constant: -32)
        ])

        normalTableHeight = [tableBaseView.heightAnchor.constraint(equalToConstant: 168)]
        errorTableHeight = [tableBaseView.heightAnchor.constraint(equalToConstant: 212)]
        updateFaceDomainInfo()
        view.bringSubviewToFront(headerView)
    }

    private func updateFaceDomainInfo() {
        if !Service.hasFaceDomainInfo {
            Configuration.eKYCProcessingStep = .verify
            NSLayoutConstraint.deactivate(normalTableHeight)
            NSLayoutConstraint.activate(errorTableHeight)
        } else {
            NSLayoutConstraint.deactivate(errorTableHeight)
            NSLayoutConstraint.activate(normalTableHeight)
        }
    }

    private func showSetting() {
        let settingVC = eKYCSettingViewController()
        pushIfAvailable(settingVC)
    }

    @objc
    private func tapStartButton() {
        let viewController = eKYCCardFrontViewController()
        pushIfAvailable(viewController)
    }
}

extension eKYCStartViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = items[safe: indexPath.row] else { return UITableViewCell() }
        switch item {
        case .all:
            if let cell = tableView.dequeueCell(RadioButtonTableViewCell_A.self, for: indexPath) {
                cell.set(title: "Verify + Face Compare")
                if Service.hasFaceDomainInfo {
                    cell.set(isEnabled: true)
                    cell.set(isSelected: Configuration.eKYCProcessingStep == .all)
                } else {
                    cell.set(isEnabled: false)
                }

                return cell
            }
        case .verify:
            if let cell = tableView.dequeueCell(RadioButtonTableViewCell_A.self, for: indexPath) {
                cell.set(title: "Verify")
                cell.set(isEnabled: true)
                cell.set(isSelected: Configuration.eKYCProcessingStep == .verify)
                return cell
            }
        case .faceCompare:
            if let cell = tableView.dequeueCell(RadioButtonTableViewCell_A.self, for: indexPath) {
                cell.set(title: "Face Compare")
                if Service.hasFaceDomainInfo {
                    cell.set(isEnabled: true)
                    cell.set(isSelected: Configuration.eKYCProcessingStep == .faceComapre)
                } else {
                    cell.set(isEnabled: false)
                }

                return cell
            }
        case .faceDomainError:
            if let cell = tableView.dequeueCell(ErrorTableViewCell.self, for: indexPath) {
                cell.set(error: "Enter the face domain information.")
                return cell
            }
        case .empty:
            if let cell = tableView.dequeueCell(EmptyTableViewCell.self, for: indexPath) {
                return cell
            }
        }

        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = items[safe: indexPath.row] else { return }
        switch item {
        case .all:
            if Service.hasFaceDomainInfo {
                Configuration.eKYCProcessingStep = .all
            }
        case .verify:
            Configuration.eKYCProcessingStep = .verify
        case .faceCompare:
            if Service.hasFaceDomainInfo {
                Configuration.eKYCProcessingStep = .faceComapre
            }
        default:
            return
        }

        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch items[safe: indexPath.item] {
        case .empty(let height):
            return height
        case .all, .verify, .faceCompare:
            return RadioButtonTableViewCell_A.height
        case .faceDomainError:
            return ErrorTableViewCell.height
        default:
            return .zero
        }
    }
}
