/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

import UIKit

import ClovaEyeD

final class eKYCIcrCheckViewController: UIViewController {

    private var document: NcpEkycApiManager.Document
    private var textInfo: [TextInfo]
    private let boundingBoxes: [[CGPoint]]

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

    private lazy var nextButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = AssetColor.clovaGreen.uiColor
        $0.tintColor = .white
        $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        $0.setTitle("Verify User", for: .normal)
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
        $0.register(TextInfoEditTableViewCell.self)
        $0.makeRoundBorder(radius: 3)
        $0.backgroundColor = AssetColor.clovaBlack.uiColor
        $0.contentInset = UIEdgeInsets(top: 20, left: .zero, bottom: 20, right: .zero)
        return $0
    }(UITableView())

    private let processingView: ProcessingView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(ProcessingView())
    
    init(cardImage: UIImage?, document: NcpEkycApiManager.Document) {
        self.textInfo = document.textInfo
        self.boundingBoxes = document.boundingBoxes
        self.document = document
        super.init(nibName: nil, bundle: nil)
        cardImageView.image = cardImage
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension eKYCIcrCheckViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        if !textInfo.isEmpty {
            tableView.scrollToRow(at: IndexPath(row: .zero, section: .zero), at: .top, animated: false)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        drawBoundingBoxes()
    }
}

extension eKYCIcrCheckViewController {

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

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: cardImageView.bottomAnchor, constant: 30),
            tableView.bottomAnchor.constraint(equalTo: retryButton.topAnchor, constant: -25),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 34),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -34)
        ])

        view.addSubview(processingView)
        NSLayoutConstraint.activate([
            processingView.topAnchor.constraint(equalTo: view.topAnchor),
            processingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            processingView.leftAnchor.constraint(equalTo: view.leftAnchor),
            processingView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])

        processingView.stop()
    }
    
    private func drawBoundingBoxes() {
        cardImageView.removeAllSublayers()
        guard let imageSize = cardImageView.image?.size else {
            return
        }

        for box in boundingBoxes {
            guard var topLeft = box[safe: 0],
                  var topRight = box[safe: 1],
                  var bottomRight = box[safe: 2],
                  var bottomLeft = box[safe: 3] else {
                continue
            }

            topLeft = topLeft.changeScale(
                to: cardImageView.frame.size, parentScreenSize: imageSize, aspectType: .fit)
            topRight = topRight.changeScale(
                to: cardImageView.frame.size, parentScreenSize: imageSize, aspectType: .fit)
            bottomRight = bottomRight.changeScale(
                to: cardImageView.frame.size, parentScreenSize: imageSize, aspectType: .fit)
            bottomLeft = bottomLeft.changeScale(
                to: cardImageView.frame.size, parentScreenSize: imageSize, aspectType: .fit)
            let color = AssetColor.clovaGreen.uiColor
            cardImageView.drawLine(from: topLeft, to: topRight, color: color)
            cardImageView.drawLine(from: topRight, to: bottomRight, color: color)
            cardImageView.drawLine(from: bottomRight, to: bottomLeft, color: color)
            cardImageView.drawLine(from: bottomLeft, to: topLeft, color: color)
        }
    }

    @objc
    private func retry() {
        if let vc = navigationController?.viewControllers.first(where: { $0 is eKYCCardFrontViewController }) {
            navigationController?.popToViewController(vc, animated: true)
        }
    }

    @objc
    private func moveNextStep() {
        processingView.play()
        let image = cardImageView.image
        ClovaManager.shared.verify(with: document, completion: { (result) in
            DispatchQueue.main.async { [weak self] in
                self?.processingView.stop()
                switch result {
                case .success(let verifyResult):
                    let vc = eKYCVerifyCheckViewController(cardImage: image, result: verifyResult)
                    self?.pushIfAvailable(vc)
                case .failure(let error):
                    switch error {
                    case .internalServerError(let error):
                        if error.code == "0022" {
                            let alert = UIAlertController(title: "Request domain invalid.", message: nil, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { [weak self] (_) in
                                self?.navigationController?.popToRootViewController(animated: true)
                            }))

                            self?.present(alert, animated: true)
                            return
                        }
                    default:
                        break
                    }
                    
                    let vc = eKYCDocumentFailViewController(
                        cardImage: image, message: error.description)
                    self?.pushIfAvailable(vc)
                }
            }
        })
    }
}

extension eKYCIcrCheckViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textInfo.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let info = textInfo[safe: indexPath.row] else { return UITableViewCell() }
        if let cell = tableView.dequeueCell(TextInfoEditTableViewCell.self, for: indexPath) {
            cell.set(title: info.title, color: AssetColor.clovaGreen.uiColor)
            if info.description.isNil {
                cell.set(value: "Recognition Failure", color: info.textColor)
            } else {
                cell.set(value: info.description, color: info.textColor)
            }

            return cell
        } else {
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let value = textInfo[safe: indexPath.row] else {
            return .zero
        }

        let font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        let valueLabelWidth = tableView.frame.size.width * 0.55
        let titleLabelWidth = tableView.frame.size.width - valueLabelWidth - 55
        let valueHeight = value.description?.height(constraintedWidth: valueLabelWidth, font: font) ?? .zero
        let titleHeight = value.title.height(constraintedWidth: titleLabelWidth, font: font)
        let margin: CGFloat = 10
        if titleHeight > valueHeight {
            return margin + titleHeight
        } else {
            return margin + valueHeight
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let value = textInfo[safe: indexPath.row] else {
            return
        }

        let alert = UIAlertController(title: nil, message: value.title, preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.textFields?.first?.text = value.description
        alert.textFields?.first?.clearButtonMode = .always
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { [weak self] (_) in
            guard let self else { return }
            guard let text = alert.textFields?.first?.text else { return }
            guard !text.isEmpty else { return }
            self.textInfo[safe: indexPath.row]?.description = text
            self.textInfo[safe: indexPath.row]?.textColor = .white
            self.document.result.ac?[value.title]?[safe: 0]?.text = text
            self.document.result.dl?[value.title]?[safe: 0]?.text = text
            self.document.result.ic?[value.title]?[safe: 0]?.text = text
            self.document.result.pp?[value.title]?[safe: 0]?.text = text
            tableView.reloadData()
        }))

        present(alert, animated: true, completion: nil)
    }
}
