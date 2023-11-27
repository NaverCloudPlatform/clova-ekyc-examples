/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

import UIKit

import ClovaEyeD

enum eKYCSetting {
    case empty(height: CGFloat)
    case serviceOptionHeader
    case idCardInvokeUrlHeader
    case idCardInvokeUrl
    case idCardSecretKeyHeader
    case idCardSecretKey
    case faceInvokeUrlHeader
    case faceInvokeUrl
    case faceSecretKeyHeader
    case faceSecretKey
    case similarityThreshold
    case detectingOptionHeader
    case faceLocationHeader
    case faceAnywhere
    case faceLeft
    case faceRight
    case spoofingOptionHeader
    case livenessSpoofingHeader
    case eyeBlink
    case mouthOpen
    case headPose
}

final class eKYCSettingViewController: UIViewController {

    private var idFaceLocation = Configuration.eKYCIdFaceLocation
    private var motionSpoofing = Configuration.eKYCMotionSpoofing
    private var similarityThreshold = Configuration.eKYCSimilarityThreshold
    private var idCardInvokeUrl = Service.idCardInvokeUrl
    private var idCardSecretKey = Service.idCardSecretKey
    private var faceInvokeUrl = Service.faceInvokeUrl
    private var faceSecretKey = Service.faceSecretKey

    private let items: [eKYCSetting] = [
        .empty(height: 10),
        .serviceOptionHeader, .empty(height: 15),
        .idCardInvokeUrlHeader, .empty(height: 15),
        .idCardInvokeUrl, .empty(height: 15),
        .idCardSecretKeyHeader, .empty(height: 15),
        .idCardSecretKey, .empty(height: 15),
        .faceInvokeUrlHeader, .empty(height: 15),
        .faceInvokeUrl, .empty(height: 15),
        .faceSecretKeyHeader, .empty(height: 15),
        .faceSecretKey, .empty(height: 30),
        .similarityThreshold, .empty(height: 30),
        .detectingOptionHeader, .empty(height: 15),
        .faceLocationHeader, .empty(height: 15),
        .faceAnywhere, .empty(height: 12),
        .faceLeft, .empty(height: 12),
        .faceRight, .empty(height: 30),
        .spoofingOptionHeader, .empty(height: 15),
        .livenessSpoofingHeader, .empty(height: 15),
        .eyeBlink, .empty(height: 12),
        .mouthOpen, .empty(height: 12),
        .headPose, .empty(height: 30)]

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    private lazy var headerView: NavigationHeaderView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.set(tintColor: .black)
        $0.tapBack = { [weak self] in self?.navigationController?.popViewController(animated: true) }
        return $0
    }(NavigationHeaderView(title: "eKYC Setting"))

    lazy var doneButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = AssetColor.clovaBlue.uiColor
        $0.tintColor = .white
        $0.titleLabel?.font = .systemFont(ofSize: 15, weight: 700)
        $0.setTitle("Done", for: .normal)
        $0.makeRoundBorder(radius: 3)
        $0.addTarget(self, action: #selector(done))
        return $0
    }(UIButton())

    private lazy var tableView: UITableView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.delegate = self
        $0.dataSource = self
        $0.register(NumberInputTableViewCell.self)
        $0.register(TextInputTableViewCell.self)
        $0.register(HeaderTableViewCell_A.self)
        $0.register(HeaderTableViewCell_B.self)
        $0.register(RadioButtonTableViewCell_B.self)
        $0.register(EmptyTableViewCell.self)
        return $0
    }(UITableView())
}

extension eKYCSettingViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
    }
}

extension eKYCSettingViewController {

    private func configureLayout() {
        view.backgroundColor = .white
        view.addSubview(headerView)
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            headerView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])

        view.addSubview(doneButton)
        NSLayoutConstraint.activate([
            doneButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -34),
            doneButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 34),
            doneButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -34),
            doneButton.heightAnchor.constraint(equalToConstant: 54)
        ])

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 34),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -34),
            tableView.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: -20)
        ])

        view.bringSubviewToFront(headerView)
    }

    @objc
    private func done() {
        navigationController?.popViewController(animated: true)
        Configuration.eKYCIdFaceLocation = idFaceLocation
        Configuration.eKYCMotionSpoofing = motionSpoofing
        Configuration.eKYCSimilarityThreshold = similarityThreshold
        Service.idCardInvokeUrl = idCardInvokeUrl
        Service.idCardSecretKey = idCardSecretKey
        Service.faceInvokeUrl = faceInvokeUrl
        Service.faceSecretKey = faceSecretKey
    }
}

extension eKYCSettingViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch items[safe: indexPath.row] {
        case .empty:
            if let cell = tableView.dequeueCell(EmptyTableViewCell.self, for: indexPath) {
                return cell
            }
        case .serviceOptionHeader:
            if let cell = tableView.dequeueCell(HeaderTableViewCell_A.self, for: indexPath) {
                cell.set(title: "Service Option")
                return cell
            }
        case .idCardInvokeUrlHeader:
            if let cell = tableView.dequeueCell(HeaderTableViewCell_B.self, for: indexPath) {
                cell.set(title: "ID Card Invoke URL")
                return cell
            }
        case .idCardInvokeUrl:
            if let cell = tableView.dequeueCell(TextInputTableViewCell.self, for: indexPath) {
                cell.set(title: "Please input id card domain invoke URL")
                cell.set(value: idCardInvokeUrl)
                cell.showAlert = { [weak self] (alert) in
                    self?.present(alert, animated: true, completion: nil)
                }

                cell.valueUpdated = { [weak self] (value) in
                    if let url = value?.trimmingCharacters(in: .whitespacesAndNewlines), !url.isEmpty {
                        self?.idCardInvokeUrl = url
                    } else {
                        let text = "Please input value."
                        let alert = UIAlertController(title: nil, message: text, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self?.present(alert, animated: true, completion: nil)
                    }

                    self?.tableView.reloadData()
                }

                return cell
            }
        case .idCardSecretKeyHeader:
            if let cell = tableView.dequeueCell(HeaderTableViewCell_B.self, for: indexPath) {
                cell.set(title: "ID Card Secret Key")
                return cell
            }
        case .idCardSecretKey:
            if let cell = tableView.dequeueCell(TextInputTableViewCell.self, for: indexPath) {
                cell.set(title: "Please input id card domain secret key")
                cell.set(value: idCardSecretKey)
                cell.showAlert = { [weak self] (alert) in
                    self?.present(alert, animated: true, completion: nil)
                }

                cell.valueUpdated = { [weak self] (value) in
                    if let key = value?.trimmingCharacters(in: .whitespacesAndNewlines), !key.isEmpty {
                        self?.idCardSecretKey = key
                    } else {
                        let text = "Please input value."
                        let alert = UIAlertController(title: nil, message: text, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self?.present(alert, animated: true, completion: nil)
                    }

                    self?.tableView.reloadData()
                }

                return cell
            }
        case .faceInvokeUrlHeader:
            if let cell = tableView.dequeueCell(HeaderTableViewCell_B.self, for: indexPath) {
                cell.set(title: "Face Invoke URL")
                return cell
            }
        case .faceInvokeUrl:
            if let cell = tableView.dequeueCell(TextInputTableViewCell.self, for: indexPath) {
                cell.set(title: "Please input face domain invoke URL")
                cell.set(value: faceInvokeUrl)
                cell.showAlert = { [weak self] (alert) in
                    self?.present(alert, animated: true, completion: nil)
                }

                cell.valueUpdated = { [weak self] (value) in
                    self?.faceInvokeUrl = value?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                }

                return cell
            }
        case .faceSecretKeyHeader:
            if let cell = tableView.dequeueCell(HeaderTableViewCell_B.self, for: indexPath) {
                cell.set(title: "Face Secret Key")
                return cell
            }
        case .faceSecretKey:
            if let cell = tableView.dequeueCell(TextInputTableViewCell.self, for: indexPath) {
                cell.set(title: "Please input face domain secret key")
                cell.set(value: faceSecretKey)
                cell.showAlert = { [weak self] (alert) in
                    self?.present(alert, animated: true, completion: nil)
                }

                cell.valueUpdated = { [weak self] (value) in
                    self?.faceSecretKey = value?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                }

                return cell
            }
        case .similarityThreshold:
            if let cell = tableView.dequeueCell(NumberInputTableViewCell.self, for: indexPath) {
                let title = "Similarity Threshold"
                let description = "More than 0.65 is\r\nrecommended."
                cell.set(title: title, description: description)
                cell.set(value: similarityThreshold)
                cell.showAlert = { [weak self] (alert) in
                    self?.present(alert, animated: true, completion: nil)
                }

                cell.valueUpdated = { [weak self] (value) in
                    self?.similarityThreshold = value
                }

                return cell
            }
        case .detectingOptionHeader:
            if let cell = tableView.dequeueCell(HeaderTableViewCell_A.self, for: indexPath) {
                cell.set(title: "Detecting Option")
                return cell
            }
        case .faceLocationHeader:
            if let cell = tableView.dequeueCell(HeaderTableViewCell_B.self, for: indexPath) {
                cell.set(title: "Face Location on ID Card")
                return cell
            }
        case .faceAnywhere:
            if let cell = tableView.dequeueCell(RadioButtonTableViewCell_B.self, for: indexPath) {
                let isSelected = idFaceLocation == .anyWhere
                cell.set(title: "Anywhere")
                cell.set(isSelected: isSelected)
                return cell
            }
        case .faceLeft:
            if let cell = tableView.dequeueCell(RadioButtonTableViewCell_B.self, for: indexPath) {
                let isSelected = idFaceLocation == .left
                cell.set(title: "Left Side")
                cell.set(isSelected: isSelected)
                return cell
            }
        case .faceRight:
            if let cell = tableView.dequeueCell(RadioButtonTableViewCell_B.self, for: indexPath) {
                let isSelected = idFaceLocation == .right
                cell.set(title: "Right Side")
                cell.set(isSelected: isSelected)
                return cell
            }
        case .spoofingOptionHeader:
            if let cell = tableView.dequeueCell(HeaderTableViewCell_A.self, for: indexPath) {
                cell.set(title: "Spoofing Option")
                return cell
            }
        case .livenessSpoofingHeader:
            if let cell = tableView.dequeueCell(HeaderTableViewCell_B.self, for: indexPath) {
                cell.set(title: "Face Expresssion Spoofing")
                return cell
            }
        case .eyeBlink:
            if let cell = tableView.dequeueCell(RadioButtonTableViewCell_B.self, for: indexPath) {
                let isSelected = motionSpoofing.contains(.eyeBlink)
                cell.set(title: "Eye Blink")
                cell.set(isSelected: isSelected)
                return cell
            }
        case .mouthOpen:
            if let cell = tableView.dequeueCell(RadioButtonTableViewCell_B.self, for: indexPath) {
                let isSelected = motionSpoofing.contains(.mouthOpen)
                cell.set(title: "Mouth Open")
                cell.set(isSelected: isSelected)
                return cell
            }
        case .headPose:
            if let cell = tableView.dequeueCell(RadioButtonTableViewCell_B.self, for: indexPath) {
                let isSelected = motionSpoofing.contains(.nod) ||
                                    motionSpoofing.contains(.roll) ||
                                    motionSpoofing.contains(.shake)
                cell.set(title: "Head Pose(angle)")
                cell.set(isSelected: isSelected)
                return cell
            }
        default:
            break
        }

        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch items[safe: indexPath.row] {
        case .empty(let height):
            return height
        case .similarityThreshold:
            return NumberInputTableViewCell.height
        case .serviceOptionHeader, .spoofingOptionHeader, .detectingOptionHeader:
            return HeaderTableViewCell_A.height
        case .idCardInvokeUrlHeader, .idCardSecretKeyHeader,
            .faceInvokeUrlHeader, .faceSecretKeyHeader,
            .faceLocationHeader, .livenessSpoofingHeader:
            return HeaderTableViewCell_B.height
        case .faceAnywhere, .faceLeft, .faceRight, .eyeBlink, .mouthOpen, .headPose:
            return RadioButtonTableViewCell_B.height
        case .idCardInvokeUrl, .idCardSecretKey, .faceInvokeUrl, .faceSecretKey:
            return TextInputTableViewCell.height
        default:
            return .zero
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch items[safe: indexPath.row] {
        case .faceAnywhere:
            idFaceLocation = .anyWhere
        case .faceLeft:
            idFaceLocation = .left
        case .faceRight:
            idFaceLocation = .right
        case .eyeBlink:
            motionSpoofing = [.eyeBlink]
        case .mouthOpen:
            motionSpoofing = [.mouthOpen]
        case .headPose:
            motionSpoofing = [.nod, .roll, .shake]
        default:
            return
        }

        tableView.reloadData()
    }
}
