/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

import UIKit

final class HomeViewController: UIViewController {

    private let scenarios = HomeScenario.values

    private let titleImageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
        $0.image = AssetImage.ncp_title.uiImage
        return $0
    }(UIImageView())

    private let titleLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "eKYC SDK Demo App"
        $0.textColor = .white.withAlphaComponent(0.5)
        $0.font = UIFont.systemFont(ofSize: 14, weight: 500)
        return $0
    }(UILabel())

    private let versionLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = Bundle.appVersion
        $0.textColor = .white.withAlphaComponent(0.5)
        $0.font = UIFont.systemFont(ofSize: 14, weight: 400)
        return $0
    }(UILabel())

    private lazy var tableView: UITableView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .clear
        $0.delegate = self
        $0.dataSource = self
        $0.register(ScenarioTableViewCell.self)
        $0.separatorStyle = .none
        return $0
    }(UITableView())
}

extension HomeViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
    }
}

extension HomeViewController {

    private func configureLayout() {
        view.backgroundColor = .black
        view.addSubview(titleImageView)
        NSLayoutConstraint.activate([
            titleImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70),
            titleImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleImageView.widthAnchor.constraint(equalToConstant: 207),
            titleImageView.heightAnchor.constraint(equalToConstant: 23)
        ])

        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: titleImageView.bottomAnchor, constant: 6),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 25)
        ])

        view.addSubview(versionLabel)
        NSLayoutConstraint.activate([
            versionLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25),
            versionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            versionLabel.heightAnchor.constraint(equalToConstant: 17)
        ])

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 45),
            tableView.bottomAnchor.constraint(equalTo: versionLabel.topAnchor, constant: -27),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 47),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -47)
        ])
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scenarios.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueCell(ScenarioTableViewCell.self, for: indexPath),
              let scenario = scenarios[safe: indexPath.row] else {
            return UITableViewCell()
        }

        cell.set(title: scenario.rawValue)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let scenario = scenarios[safe: indexPath.row] else { return }
        let viewController: UIViewController
        switch scenario {
        case .ekyc:
            viewController = eKYCStartViewController()
        }

        pushIfAvailable(viewController)
    }
}
