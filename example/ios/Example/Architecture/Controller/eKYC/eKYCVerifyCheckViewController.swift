/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

import UIKit

import ClovaEyeD

final class eKYCVerifyCheckViewController: UIViewController {

    enum ResultViewMode {
        case verifyResult
        case apiResult
    }

    private let result: NcpEkycApiManager.VerifyResult
    private let textInfo: [TextInfo]
    private let jsonString: String
    private var viewMode = ResultViewMode.verifyResult {
        didSet {
            tableView.reloadData()
        }
    }

    private let headerLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: 17, weight: 700)
        $0.textColor = .white
        $0.textAlignment = .center
        $0.text = "Analysis"
        return $0
    }(UILabel())

    private let cardImageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())

    private lazy var retryButton: RetryButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addTarget(self, action: #selector(retry))
        return $0
    }(RetryButton())

    private let contentView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.makeRoundBorder(radius: 3)
        $0.backgroundColor = .clear
        $0.clipsToBounds = true
        return $0
    }(UIView())

    private lazy var verifyResultButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("Result", for: .normal)
        $0.tintColor = .white
        $0.titleLabel?.font = .systemFont(ofSize: 15, weight: 600)
        $0.addTarget(self, action: #selector(showVerifyResult))
        return $0
    }(UIButton())

    private lazy var apiResultButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("API result", for: .normal)
        $0.tintColor = .white
        $0.titleLabel?.font = .systemFont(ofSize: 15, weight: 600)
        $0.addTarget(self, action: #selector(showApiResult))
        return $0
    }(UIButton())

    private lazy var nextButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = AssetColor.clovaGreen.uiColor
        $0.tintColor = .white
        $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        switch Configuration.eKYCProcessingStep {
        case .all:
            $0.setTitle("Move to Next Step", for: .normal)
        default:
            $0.setTitle("Move to Main Menu", for: .normal)
        }

        $0.makeRoundBorder(radius: 3)
        $0.addTarget(self, action: #selector(moveNextStep))
        return $0
    }(UIButton())

    private lazy var tableView: UITableView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.delegate = self
        $0.dataSource = self
        $0.register(TextInfoTableViewCell.self)
        $0.register(TextTableViewCell.self)
        $0.backgroundColor = AssetColor.clovaBlack.uiColor
        $0.contentInset = UIEdgeInsets(top: 20, left: .zero, bottom: 20, right: .zero)
        return $0
    }(UITableView())

    init(cardImage: UIImage?, result: NcpEkycApiManager.VerifyResult) {
        self.result = result
        var textInfo: [TextInfo] = []
        textInfo.append(TextInfo(title: "Type", description: result.inferType, textColor: .white))
        textInfo.append(TextInfo(title: "Detail Type", description: result.inferDetailType, textColor: .white))
        switch result.result {
        case .failure:
            textInfo.append(TextInfo(title: "Error Code", description: result.code?.description ?? "", textColor: .white))
            textInfo.append(TextInfo(title: "Message", description: result.message, textColor: .white))
        default:
            break
        }

        self.textInfo = textInfo
        let jsonEncoder = JSONEncoder()
        if let jsonData = try? jsonEncoder.encode(result) {
            self.jsonString = String(data: jsonData, encoding: String.Encoding.utf8) ?? ""
        } else {
            self.jsonString = ""
        }

        super.init(nibName: nil, bundle: nil)
        cardImageView.image = cardImage
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension eKYCVerifyCheckViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
    }
}

extension eKYCVerifyCheckViewController {

    private func configureLayout() {
        view.backgroundColor = .black
        view.addSubview(headerLabel)
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
            headerLabel.rightAnchor.constraint(equalTo: view.rightAnchor),
            headerLabel.heightAnchor.constraint(equalToConstant: 56)
        ])

        view.addSubview(nextButton)
        NSLayoutConstraint.activate([
            nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -34),
            nextButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 34),
            nextButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -34),
            nextButton.heightAnchor.constraint(equalToConstant: 54)
        ])

        view.addSubview(retryButton)
        NSLayoutConstraint.activate([
            retryButton.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -25),
            retryButton.heightAnchor.constraint(equalToConstant: 30),
            retryButton.widthAnchor.constraint(equalToConstant: 65),
            retryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])

        view.addSubview(cardImageView)
        NSLayoutConstraint.activate([
            cardImageView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 15),
            cardImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 34),
            cardImageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -34),
            cardImageView.widthAnchor.constraint(equalTo: cardImageView.heightAnchor,
                                                 multiplier: 1/CardAngle.angle90.boundingBoxRatio)
        ])

        view.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: cardImageView.bottomAnchor, constant: 30),
            contentView.bottomAnchor.constraint(equalTo: retryButton.topAnchor, constant: -25),
            contentView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 34),
            contentView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -34),
        ])

        contentView.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 48),
            tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: contentView.rightAnchor)
        ])

        contentView.addSubview(verifyResultButton)
        NSLayoutConstraint.activate([
            verifyResultButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            verifyResultButton.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            verifyResultButton.widthAnchor.constraint(equalTo: tableView.widthAnchor, multiplier: 0.5),
            verifyResultButton.heightAnchor.constraint(equalToConstant: 48)
        ])

        contentView.addSubview(apiResultButton)
        NSLayoutConstraint.activate([
            apiResultButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            apiResultButton.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            apiResultButton.widthAnchor.constraint(equalTo: tableView.widthAnchor, multiplier: 0.5),
            apiResultButton.heightAnchor.constraint(equalToConstant: 48)
        ])

        showVerifyResult()
    }

    @objc
    private func retry() {
        navigationController?.popViewController(animated: true)
    }

    @objc
    private func moveNextStep() {
        switch Configuration.eKYCProcessingStep {
        case .all:
            let vc = eKYCFaceShotViewController()
            pushIfAvailable(vc)
        default:
            if let faceVC = navigationController?.viewControllers.first(where: { $0 is HomeViewController }) {
                navigationController?.popToViewController(faceVC, animated: true)
            }
        }
    }

    @objc
    private func showVerifyResult() {
        viewMode = .verifyResult
        verifyResultButton.backgroundColor = AssetColor.clovaBlack.uiColor
        apiResultButton.backgroundColor = AssetColor.clovaBlack.uiColor?.withAlphaComponent(0.5)
    }

    @objc
    private func showApiResult() {
        viewMode = .apiResult
        verifyResultButton.backgroundColor = AssetColor.clovaBlack.uiColor?.withAlphaComponent(0.5)
        apiResultButton.backgroundColor = AssetColor.clovaBlack.uiColor
    }
}

extension eKYCVerifyCheckViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewMode {
        case .verifyResult:
            return textInfo.count + 1
        case .apiResult:
            return 2
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == .zero, let cell = tableView.dequeueCell(TextInfoTableViewCell.self, for: indexPath) {
            cell.set(title: "Result", color: .white)
            switch result.result {
            case .success:
                cell.set(value: "Success", color: AssetColor.clovaGreen.uiColor)
            default:
                cell.set(value: "Failure", color: AssetColor.clovaRed.uiColor)
            }

            return cell
        }

        switch viewMode {
        case .verifyResult:
            if let info = textInfo[safe: indexPath.row - 1],
               let cell = tableView.dequeueCell(TextInfoTableViewCell.self, for: indexPath) {
                cell.set(title: info.title, color: .white)
                cell.set(value: info.description, color: info.textColor)
                return cell
            }
        case .apiResult:
            if let cell = tableView.dequeueCell(TextTableViewCell.self, for: indexPath) {
                cell.set(value: jsonString)
                return cell
            }
        }

        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == .zero {
            return 30
        }

        let font = UIFont.systemFont(ofSize: 14, weight: 500)
        switch viewMode {
        case .verifyResult:
            if let info = textInfo[safe: indexPath.row - 1] {
                let valueLabelWidth = tableView.frame.size.width * 0.55
                let titleLabelWidth = tableView.frame.size.width - valueLabelWidth - 55
                let valueHeight = info.description?.height(constraintedWidth: valueLabelWidth, font: font) ?? .zero
                let titleHeight = info.title.height(constraintedWidth: titleLabelWidth, font: font)
                let margin: CGFloat = 10
                if titleHeight > valueHeight {
                    return margin + titleHeight
                } else {
                    return margin + valueHeight
                }
            }
        case .apiResult:
            let valueLabelWidth = tableView.frame.size.width - 40
            let valueHeight = jsonString.height(constraintedWidth: valueLabelWidth, font: font)
            return valueHeight + 30
        }

        return .zero
    }
}
