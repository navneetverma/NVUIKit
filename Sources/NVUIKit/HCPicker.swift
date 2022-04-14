//
//  HCPicker.swift
//  HealthcareIP
//
//  Created by Navneet.verma on 2/18/22.
//

import Foundation
import UIKit

public final class HCPicker: UIView {

    // MARK: - Properties

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = menuTitle
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Select..."
        label.textColor = UIColor.Gray.placeholderText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var arrowImageView: UIImageView = {
        let arrowImageView = UIImageView(image: deselectedImage)
        arrowImageView.contentMode = .center
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        return arrowImageView
    }()

    private lazy var contextMenuStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [label, arrowImageView])
        stackView.backgroundColor = .white
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var contextMenuContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 3
        view.layer.borderColor = Constants.inactiveColor.cgColor
        view.layer.borderWidth = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contextMenuStackView)
        return view
    }()

    private lazy var gestureRecognizer: UITapGestureRecognizer = {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(menuTapped))
        return gestureRecognizer
    }()
    
    public weak var delegate: PickerMenuDelegate?

    enum Constants {
        static let activeBorderColor = UIColor.Slate.base
        static let inactiveColor = UIColor.Gray.light
        static let errorBorderColor = UIColor.Red.base
    }

    private var presentingViewController: UIViewController
    private var menuTitle: String

    public var options: [String]
    public var selectedOption: String? {
        didSet {
            if let selectedOption = selectedOption {
                label.text = selectedOption
            } else {
                label.text = menuTitle
            }
        }
    }
    var deselectedImage: UIImage
    var selectedImage: UIImage

    // MARK: - Lifecycle

    required init?(coder: NSCoder) { fatalError("init() has not been implemented") }

    public required init(
        presentingViewController: UIViewController,
        menuTitle: String,
        options: [String] = ["A","B"],
        selectedOption: String? = nil,
        deselectedImage: UIImage,
        selectedImage: UIImage
    ) {
        self.presentingViewController = presentingViewController
        self.menuTitle = menuTitle
        self.options = options
        self.selectedOption = selectedOption
        self.deselectedImage = deselectedImage
        self.selectedImage = selectedImage
        super.init(frame: .zero)
        setupView()
    }

    // MARK: - Setup

    private func setupView() {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, contextMenuContainerView])
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stackView)
        addGestureRecognizer(gestureRecognizer)

        NSLayoutConstraint.activate([
            arrowImageView.widthAnchor.constraint(equalToConstant: 35),
            contextMenuStackView.leadingAnchor.constraint(equalTo: contextMenuContainerView.leadingAnchor, constant: 5),
            contextMenuStackView.trailingAnchor.constraint(equalTo: contextMenuContainerView.trailingAnchor, constant: -5),
            contextMenuStackView.topAnchor.constraint(equalTo: contextMenuContainerView.topAnchor, constant: 5),
            contextMenuStackView.centerYAnchor.constraint(equalTo: contextMenuContainerView.centerYAnchor),
            contextMenuStackView.heightAnchor.constraint(equalToConstant: 35),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    // MARK: - Actions

    @objc private func menuTapped() {
        presentingViewController.resignFirstResponder()
        presentingViewController.view.endEditing(true)
        let menuItems = HCMenuItemsPicker(options: options, selectedOption: selectedOption)
        menuItems.pickerDelegate = self
        addSubview(menuItems)
        menuItems.showPicker()
    }

}

extension HCPicker: MenuItemsViewControllerDelegate {
   
    
    // MARK: - MenuItemsViewControllerDelegate

    func menuOptionsPresented() {
        contextMenuContainerView.layer.borderColor = Constants.activeBorderColor.cgColor
        arrowImageView.image = selectedImage
    }

    func menuOptionsHidden() {
        contextMenuContainerView.layer.borderColor = Constants.inactiveColor.cgColor
        arrowImageView.image = deselectedImage
    }

    func select(option: String) {
        guard selectedOption != option else { return }
        selectedOption = option
        delegate?.PickerMenu(didSelect: option)
        label.textColor = UIColor.Gray.placeholderText
        label.text = option
    }
}
