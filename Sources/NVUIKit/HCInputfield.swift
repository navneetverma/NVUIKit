//
//  HCInputfield.swift
//  HealthcareIP
//
//  Created by Navneet.verma on 2/14/22.
//

import Foundation
import UIKit

public protocol HCInputFieldDelegate: AnyObject {
    func textFieldTextDidChange(_ text: String?, from inputField: HCInputField)
    func canMoveToNextField(from: HCInputField) -> Bool
    func moveToNextField(after: HCInputField)
    func didtapOnBiometric()
}

public struct HCInputFieldAppearance {
    public let visibleIcon: UIImage?
    public let invisibleIcon: UIImage?
    public var isbiometric: Bool?
    public init(visibleIcon: UIImage?, invisibleIcon: UIImage?) {
        self.visibleIcon = visibleIcon
        self.invisibleIcon = invisibleIcon
    }
}

public class HCInputField: UIView, UITextFieldDelegate {
    
    // MARK: - Properties
    
    private enum Constants {
        static let defaultBorderColor = UIColor.Gray.border
        static let activeBorderColor = UIColor.Green.base
        static let errorBorderColor = UIColor.Red.error
        static let titleColor = UIColor.gray
        static let visibilityToggleTitleHide = "Hide"
        static let visibilityToggleTitleShow = "Show"
    }
    public weak var delegate: HCInputFieldDelegate?
    
    
    public lazy var textField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.layer.cornerRadius = 10.0
        textField.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13, *) {
            textField.overrideUserInterfaceStyle = .light
        }
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textField.setContentCompressionResistancePriority(.required, for: .vertical)
        textField.setContentHuggingPriority(.required, for: .vertical)
        return textField
    }()
    
    private lazy var textFieldSecureButtonToggle: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(textFieldSecureButtonTapped), for: .touchUpInside)
        button.tintColor = UIColor.Gray.dark
        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.setContentCompressionResistancePriority(.required, for: .vertical)
        button.setContentHuggingPriority(.defaultLow, for: .vertical)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 22.5),
            button.heightAnchor.constraint(equalToConstant: 15)
        ])
        return button
    }()
    
    private lazy var textFieldStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [textField, textFieldSecureButtonToggle])
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        textFieldSecureButtonToggle.heightAnchor.constraint(equalTo: textField.heightAnchor).isActive = true
        return stackView
    }()
    
    lazy var textFieldContainer: UIView = {
        let view = HCTextFieldContainer()
        view.backgroundColor = .white
        view.layer.cornerRadius = 3
        view.layer.borderWidth = 1
        view.layer.borderColor = Constants.defaultBorderColor.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textFieldStackView)
        NSLayoutConstraint.activate([
            textFieldStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            textFieldStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            textFieldStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            textFieldStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            textFieldStackView.heightAnchor.constraint(equalToConstant: 55),
            textField.heightAnchor.constraint(equalToConstant: 55)
        ])
        return view
    }()
    
    
    let titleLabel = UILabel()
    
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.Red.error
        return label
    }()
    
    lazy var errorView: UIView = {
        let imageView = UIImageView(image: UIImage(named: "info"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let errorView = UIView()
        errorView.isHidden = true
        self.addSubview(errorView)
        errorView.addSubview(errorLabel)
        errorView.addSubview(imageView)
        errorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 12.5),
            imageView.widthAnchor.constraint(equalToConstant: 12.5),
            imageView.leadingAnchor.constraint(equalTo: errorView.leadingAnchor, constant: 5),
            errorLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 5),
            errorLabel.trailingAnchor.constraint(equalTo: errorView.trailingAnchor, constant: -5),
            errorLabel.topAnchor.constraint(greaterThanOrEqualTo: errorView.topAnchor, constant: 5),
            imageView.centerYAnchor.constraint(equalTo: errorView.topAnchor, constant: 15),
            errorLabel.centerYAnchor.constraint(equalTo: errorView.centerYAnchor, constant: 5)
        ])
        return errorView
        
    }()
    
    public var textValidationBlock: ((String?) -> Result<Void, Error>)?
    
    /// Error attached to a text field that does not clear automatically.
    
    /// This error has a higher priority over the `temporaryError` and will
    
    /// display this error until it is `nil`
    
    public var error: Error? {
        didSet {
            updateErrorState()
        }
    }
    
    /// Error attached to the text field that is cleared after input
    
    public var temporaryError: Error? {
        didSet {
            updateErrorState()
        }
    }
    
    public var isSecureEntry: Bool = false {
        didSet {
            textField.isSecureTextEntry = isSecureEntry
            textFieldSecureButtonToggle.isHidden = !isSecureEntry
            updateTextFieldSecureToggleButton()
        }
    }
    
    public var isTextVisible: Bool {
        return !textField.isSecureTextEntry
    }
    
    public var appearance: HCInputFieldAppearance? {
        didSet {
            updateTextFieldSecureToggleButton()
        }
    }
    
    public var currentValue: String? {
        textField.text
    }
    
    public var title: String? {
        didSet {
            titleLabel.text = title
            titleLabel.isHidden = title == nil
        }
    }
    
    public var characterLimit: Int?
    
    // MARK: - Lifecycle
    
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    
    public init(title: String?, placeholder: String?,
                isSecureEntry: Bool = false,
                keyboardType: UIKeyboardType = .default,
                autocapitalizationType: UITextAutocapitalizationType = .none,
                autocorrectionType: UITextAutocorrectionType = .no) {
        self.title = title
        self.isSecureEntry = isSecureEntry
        super.init(frame: .zero)
        setup()
        titleLabel.text = title
        titleLabel.isHidden = title == nil
        textField.placeholder = placeholder
        textField.keyboardType = keyboardType
        textField.isSecureTextEntry = isSecureEntry
        textField.autocapitalizationType = autocapitalizationType
        textField.autocorrectionType = autocorrectionType
        textFieldSecureButtonToggle.isHidden = !isSecureEntry
        updateTextFieldSecureToggleButton()
    }
    
    
    override public func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        _ = textField.becomeFirstResponder()
        return true
    }
    
    
    public override func resignFirstResponder() -> Bool {
        super.resignFirstResponder()
        _ = textField.resignFirstResponder()
        return true
    }
    
    
    // MARK: - Actions
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        temporaryError = nil
        delegate?.textFieldTextDidChange(textField.text, from: self)
    }
    
    
    public func validate() {
        guard let textValidationBlock = textValidationBlock else {
            textFieldContainer.layer.borderColor = Constants.defaultBorderColor.cgColor
            errorLabel.text = nil
            return
        }
        switch textValidationBlock(textField.text) {
        case .success:
            self.temporaryError = nil
        case .failure(let error):
            self.temporaryError = error
        }
    }
    
    @objc private func textFieldSecureButtonTapped() {
        textField.isSecureTextEntry.toggle()
        updateTextFieldSecureToggleButton()
    }
    private func updateTextFieldSecureToggleButton() {
        if let appearance = appearance {
            if appearance.isbiometric ?? false {
                delegate?.didtapOnBiometric()
            } else {
                textFieldSecureButtonToggle.setImage(isTextVisible ? appearance.visibleIcon : appearance.invisibleIcon, for: .normal)
                textFieldSecureButtonToggle.setTitle(nil, for: .normal)
            }
        } else {
            textFieldSecureButtonToggle.setImage(nil, for: .normal)
            textFieldSecureButtonToggle.setTitle(isTextVisible ? Constants.visibilityToggleTitleHide : Constants.visibilityToggleTitleShow, for: .normal)
        }
    }
    
    private func updateErrorState() {
        
        if let error = error ?? temporaryError {
            textFieldContainer.layer.borderColor = Constants.errorBorderColor.cgColor
            errorLabel.text = error.localizedDescription
            errorView.isHidden = false
        } else {
            textFieldContainer.layer.borderColor = textField.isFirstResponder ? Constants.activeBorderColor.cgColor : Constants.defaultBorderColor.cgColor
            errorLabel.text = nil
            errorView.isHidden = true
        }
        
    }
    // MARK: Setup
    
    
    private func setup() {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, textFieldContainer, errorView])
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 20),
            textFieldContainer.heightAnchor.constraint(equalToConstant: 65)
        ])
        
    }
    
    
    // MARK: - UITextFieldDelegate
    
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        let hasActiveError = !(error == nil && temporaryError == nil)
        textFieldContainer.layer.borderColor = hasActiveError ? Constants.errorBorderColor.cgColor : Constants.activeBorderColor.cgColor
        
        if delegate?.canMoveToNextField(from: self) == true {
            textField.returnKeyType = .next
        } else {
            textField.returnKeyType = .done
        }
    }
    
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        guard error == nil else { return }
        validate()
    }
    
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let characterLimit = characterLimit else { return true }
        if range.length + range.location > (textField.text?.count ?? 0) {
            return false
        }
        let newLength = (textField.text?.count ?? 0) + string.count - range.length
        
        if newLength <= characterLimit {
            return true
            
        } else {
            return false
        }
        
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        delegate?.moveToNextField(after: self)
        return false
    }
    
}
