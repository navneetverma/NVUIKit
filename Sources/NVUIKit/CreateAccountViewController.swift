//
//  CreateAccountViewController.swift
//  HealthcareIP
//
//  Created by Navneet.verma on 2/16/22.
//

import Foundation
import UIKit

protocol AddButtonDidClickProtocol: AnyObject {
    func addButtonDidClick(firstName: String, lastName: String, email: String, phone: String, region: String, dob: String, password: String)
}

public class CreateAccountViewController: UIViewController, UITextFieldDelegate, PickerMenuDelegate  {
    
    private enum Constants {
        static let title = "Let's get started"
        static let firstName = "First Name"
        static let lastName = "Last Name"
        static let email = "Email".localized()
        static let password = "Password"
        static let confirmPassword = "Confirm Password"
        static let phone = "Phone"
        static let phonePlaceholder = "1234567890"
    }
    
    public enum ValidRegEx: String {
        case password =  #"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&#^])[A-Za-z\d@$!%*?&#^]{8,}$"#
        case email =  #"\S+@\S+\.\S+"#
        case name  =  #"^[ a-zA-Z\-\']+$"#
        case phone = #"^\([2-9]\d{2}\)\d{3}-\d{4}$"#
    }
    
    public enum ValidationError: LocalizedError {
        case invalidEmail
        case invalidPhone
        case wrongPassword
        case emptyFirstName
        case emptyLastName
        case invalidDate
        case passwordMismatch
        public var errorDescription: String? {
            switch self {
            case .invalidEmail:
                return "Must have valid email"
            case .invalidPhone:
                return "Please enter a valid U.S. phone number"
            case .wrongPassword:
                return "Password needs to be at least 8 characters long, has to include a mix of lower case and upper case letters and digits"
            case .passwordMismatch:
                return "Password and Confirm password does not match"
            case .emptyFirstName:
                return "First Name is blank"
            case .emptyLastName:
                return "Last Name is blank"
            case .invalidDate:
                return "Invalid date or You must be 18 years old to create an account"
            }
        }
    }
    
    private lazy var scrollView: UIScrollView  = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = screenTitle ?? Constants.title
        return label
    }()
    
    lazy var  firstNameTextField: HCInputField = {
        let inputField = HCInputField(title: firstNameTitle ?? Constants.firstName, placeholder: Constants.firstName, isSecureEntry: false)
        inputField.textValidationBlock = { [weak self] (text) -> Result<Void, Error> in
            guard let self = self else { return .success(()) }
            if  !(text?.isEmpty ?? false) && ((text?.hasOnlySpace()) != nil)  {
                return .success(())
            } else {
                return .failure(ValidationError.emptyFirstName)
            }
        }
        return inputField
    }()
    
    lazy var lastNameTextField: HCInputField = {
        let inputField =  HCInputField(title: lastNameTitle ?? Constants.lastName,
                                       placeholder: Constants.lastName,
                                       isSecureEntry: false)
        inputField.textValidationBlock = { [weak self] (text) -> Result<Void, Error> in
            guard let self = self else { return .success(()) }
            if !(text?.isEmpty ?? false) && ((text?.hasOnlySpace()) != nil)  {
                return .success(())
            } else {
                return .failure(ValidationError.emptyLastName)
            }
        }
        return inputField
    }()
    
   lazy var picker: HCPicker = HCPicker(presentingViewController: self,
                                   menuTitle: "Region",
                                        deselectedImage: (upArrowImage ??  UIImage(named: "DownArrow", in: Bundle(for: CreateAccountViewController.self), compatibleWith: nil))!,
                                        selectedImage: (downArrowImage ??  UIImage(named: "DownArrow", in: Bundle(for: CreateAccountViewController.self), compatibleWith: nil))!)
    
    lazy var emailTextField: HCInputField = {
        let inputField =  HCInputField(title: emailTitle ?? Constants.email,
                                       placeholder: "CreateAccount.email.placeholder".localized(),
                                       isSecureEntry: false)
        inputField.textValidationBlock = { [weak self] (text) -> Result<Void, Error> in
            guard let self = self else { return .success(()) }
            if !(text?.isEmpty ?? false) && ((text?.hasOnlySpace()) != nil) && (self.isValidText(text, regEx: .email))  {
                return .success(())
            } else {
                return .failure(ValidationError.invalidEmail)
            }
        }
        return inputField
    }()
    
    lazy var passwordTextField: HCInputField = {
        let inputField =  HCInputField(title: passwordTitle ?? Constants.password,
                                       placeholder: Constants.password,
                                       isSecureEntry: true)
        inputField.appearance = HCInputFieldAppearance(visibleIcon: showPasswordImage ?? UIImage(named: "icon show-hide", in: Bundle(for: CreateAccountViewController.self), compatibleWith: nil),
                                                       invisibleIcon: hidePasswordImage ?? UIImage(named:  "icon hide", in: Bundle(for: CreateAccountViewController.self), compatibleWith: nil))
        inputField.textValidationBlock = { [weak self] (text) -> Result<Void, Error> in
            guard let self = self else { return .success(()) }
            if !(text?.isEmpty ?? false) && ((text?.hasOnlySpace()) != nil) && (self.isValidText(text, regEx: .password)) {
                return .success(())
            } else {
                return .failure(ValidationError.wrongPassword)
            }
        }
        return inputField
    }()
    
    lazy var confirmPasswordTextField: HCInputField = {
        let inputField =  HCInputField(title:  confirmPasswordTitle ?? Constants.confirmPassword,
                                       placeholder: Constants.password,
                                       isSecureEntry: true)
        inputField.appearance = HCInputFieldAppearance(visibleIcon:showPasswordImage ?? UIImage(named: "icon show-hide", in: Bundle(for: CreateAccountViewController.self), compatibleWith: nil),
                                                       invisibleIcon: hidePasswordImage ?? UIImage(named:  "icon hide", in: Bundle(for: CreateAccountViewController.self), compatibleWith: nil))
        inputField.textValidationBlock = { [weak self] (text) -> Result<Void, Error> in
            guard let self = self else { return .success(()) }
            if !(text?.isEmpty ?? false) && ((text?.hasOnlySpace()) != nil) && (self.isValidText(text, regEx: .password)) {
                return .success(())
            } else {
                return .failure(ValidationError.wrongPassword)
            }
        }
        return inputField
    }()
    
    lazy var phoneTextField: HCInputField = {
        let inputField =  HCInputField(title: (String(phoneTitle ?? Constants.phone)),
                                       placeholder: Constants.phonePlaceholder,
                                       isSecureEntry: false)
        inputField.textField.keyboardType = .numberPad
        inputField.appearance = HCInputFieldAppearance(visibleIcon:
                                                        UIImage(named: "show"),
                                                       invisibleIcon: UIImage(named: "hide"))
        inputField.textValidationBlock = { [weak self] (text) -> Result<Void, Error> in
            guard let self = self else { return .success(()) }
            if !(text?.isEmpty ?? false) && ((text?.hasOnlySpace()) != nil) && (self.isValidText(text, regEx: .phone))   {
                return .success(())
            } else {
                return .failure(ValidationError.invalidPhone)
            }
        }
        return inputField
    }()
    
    
    
    var isButtonEnabled: Bool = false {
        willSet(newValue) {
            if newValue {
                createButton.isEnabled = true
                createButton.setTitleColor(.white, for: .normal)
                createButton.backgroundColor = UIColor.orange
            } else {
                createButton.isEnabled = false
                createButton.setTitleColor(UIColor.Gray.dark, for: .normal)
                createButton.backgroundColor = UIColor.Gray.light
            }
        }
    }
    
    
    lazy var createButton: HCButton = HCButton(title: "Create Account", type: .filled)
    
    lazy var inputFieldGroup: HCInputFieldGroup = {
        let inputFieldGroup = HCInputFieldGroup(fields: [firstNameTextField, lastNameTextField, emailTextField, passwordTextField, phoneTextField], shouldClearErrors: true, textFieldTextDidChange: { [self] text, inputField in
            if inputField == self.passwordTextField || inputField == self.confirmPasswordTextField {
                if self.isValidText(text, regEx: .password) && !(text?.isEmpty ?? false) && ((text?.hasOnlySpace()) != nil) && !self.areAnyEmpty() {
                    self.isButtonEnabled = true
                }
                if inputField == self.confirmPasswordTextField {
                    if text != confirmPasswordTextField.textField.text {
                        
                    }
                }
            } else {
                self.isButtonEnabled = false
            }
            if inputField == self.emailTextField {
                if self.isValidText(text, regEx: .email) && !(text?.isEmpty ?? false) && ((text?.hasOnlySpace()) != nil) && !self.areAnyEmpty()  {
                    self.isButtonEnabled = true
                } else {
                    self.isButtonEnabled = false
                }
            }
        /*if inputField == self.phoneTextField {
                if self.isValidText(text, regEx: .phone) && !(text?.count ?? 0 < 10) && ((text?.hasOnlySpace()) != nil) && !self.areAnyEmpty()
                {
                    self.isButtonEnabled = true
                } else {
                    self.isButtonEnabled = false
                }
            } */
            if inputField == self.firstNameTextField || inputField == self.lastNameTextField  {
                if !(text?.isEmpty ?? false) && !self.areAnyEmpty() {
                    self.isButtonEnabled = true
                } else {
                    self.isButtonEnabled = false
                }
            }
        }, completion: {
           // self.createButton.isEnabled = true
            print("Returned on the last cell")
        })
        return inputFieldGroup
    }()
    
    lazy var stackView: UIStackView  = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel,
                                                       firstNameTextField,
                                                       lastNameTextField,
                                                       phoneTextField,
                                                       emailTextField,
                                                       picker,
                                                       passwordTextField,
                                                       confirmPasswordTextField,
                                                       createButton])
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 15
        view.addSubview(stackView)
        return stackView
    }()
    
    let screenTitle: String?
    let firstNameTitle: String?
    let lastNameTitle: String?
    let emailTitle:  String?
    let passwordTitle:  String?
    let confirmPasswordTitle: String?
    let phoneTitle: String?
    let dobTitle: String?
    let pickerTitle: String?
    let pickerOptions: [String]?
    let downArrowImage: UIImage?
    let upArrowImage: UIImage?
    let showPasswordImage: UIImage?
    let hidePasswordImage: UIImage?
    
    public var selectedOption = ""
    weak var delegate: AddButtonDidClickProtocol?
    
    public init(screenTitle: String? = nil,
         firstNameFieldTitle: String? = nil,
         lastNameFieldTitle: String? = nil,
         emailFieldTitle: String? = nil ,
         passwordFieldTitle: String? = nil,
         confirmPasswordFieldTitle: String? = nil,
         phoneFieldTitle: String? = nil,
         dobFieldTitle: String? = nil,
         pickerTitle: String? = nil,
         pickerOptions: [String]? = nil,
         downArrowImage: UIImage? = nil,
         upArrowImage: UIImage? = nil,
         showPasswordImage: UIImage? = nil,
         hidePasswordImage: UIImage? = nil) {
        self.screenTitle = screenTitle
        firstNameTitle = firstNameFieldTitle
        lastNameTitle = lastNameFieldTitle
        passwordTitle = passwordFieldTitle
        phoneTitle = phoneFieldTitle
        dobTitle = dobFieldTitle
        emailTitle = emailFieldTitle
        confirmPasswordTitle = confirmPasswordFieldTitle
        self.pickerOptions = pickerOptions
        self.pickerTitle = pickerTitle
        self.downArrowImage = downArrowImage
        self.upArrowImage = upArrowImage
        self.showPasswordImage = showPasswordImage
        self.hidePasswordImage = hidePasswordImage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.Gray.backgroundlight
        inputFieldGroup.becomeFirstResponder()
        picker.options = pickerOptions ?? []
        picker.delegate = self
        picker.translatesAutoresizingMaskIntoConstraints = false
        setupView()
    }
    
    private func setupView() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            createButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    public func PickerMenu(didSelect option: String) {
        selectedOption = option
    }
    
    private func isValidText(_ text: String?, regEx: ValidRegEx) -> Bool {
        guard let text = text else { return true }
        let regex = regEx.rawValue
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", regex)
        return emailPred.evaluate(with: text)
    }
    
    private func isValidDate(date: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/DD/YYYY"

        if let dateOfBirth = dateFormatter.date(from: date) {
            let today = NSDate()
            let gregorian = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
            let age = gregorian!.components([.year], from: dateOfBirth, to: today as Date, options: [])
            return age.year! < 18
        }
        return false
    }
    
    private func areAnyEmpty() -> Bool {
        for input in inputFieldGroup.fields {
            if input.textField.text?.isEmpty ?? false && ((input.textField.text?.hasOnlySpace()) != nil) {
                return true
            }
        }
        return false
    }
}

extension String {
    func localized() -> String {
        return NSLocalizedString(self, tableName: nil, bundle:  Bundle(for: CreateAccountViewController.self), value: "", comment: "")
    }
    
    func hasOnlySpace() -> Bool{
        return self.trimmingCharacters(in: .whitespaces).isEmpty
    }
}
