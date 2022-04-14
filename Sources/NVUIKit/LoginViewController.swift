//
//  LoginViewController.swift
//  HealthcareIP
//
//  Created by Jigar.Patel on 2/18/22.
//

import UIKit
import Foundation

protocol AddLoginButtonDidClickProtocol: AnyObject {
    func addLoginButtonDidClick(email: String, password: String, rememberme: Bool, enableFaceId: Bool)
    func addCreateAccountButtonDidClick()
    func addContinueAsGuestButtonDidClick()
    func addForgotPasswordButtonDidClick()

}

public class LoginViewController: UIViewController, UITextFieldDelegate {
    
    private enum Constants {
        static let title = "Login.title".localized()
        static let email = "Login.email".localized()
        static let password = "Login.password".localized()
        static let rememberMe = "Login.rememberMe".localized()
        static let enableFaceId = "Login.enableFaceId".localized()
        static let login = "Login.login".localized()
        static let createAccount = "Login.createAccount".localized()
        static let continueAsGuest = "Login.continueAsGuest".localized()
        static let forgotPassword = "Login.forgotPassword".localized()
    }
    public enum ValidRegEx: String {
        case password =  #"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&#^])[A-Za-z\d@$!%*?&#^]{8,}$"#
        case email =  #"\S+@\S+\.\S+"#
    }
    
    public enum ValidationError: LocalizedError {
        case invalidEmail
        case wrongPassword
        
        public var errorDescription: String? {
            switch self {
            case .invalidEmail:
                return "Login.error.email".localized()
            case .wrongPassword:
                return "Login.error.password".localized()
            }
        }
    }
    
    private lazy var scrollView: UIScrollView  = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    lazy var headerImageview: UIImageView = {
        let imageview = UIImageView()
        imageview.image = headerImage ?? UIImage(named: "Swoosh.login", in: Bundle(for: CreateAccountViewController.self), compatibleWith: nil)
        imageview.contentMode = .scaleAspectFit
        return imageview
    }()
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = screenTitle ?? Constants.title
        label.textAlignment = .center
        return label
    }()
    
    lazy var emailTextField: HCInputField = {
        let inputField =  HCInputField(title: emailTitle ?? Constants.email,
                                       placeholder: Constants.email,
                                       isSecureEntry: false)
        inputField.textValidationBlock = { [weak self] (text) -> Result<Void, Error> in
            guard let self = self else { return .success(()) }
            if !(text?.isEmpty ?? false) && ((text?.hasOnlySpace()) != nil)  {
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
        inputField.appearance = HCInputFieldAppearance(visibleIcon: showPasswordImage ?? UIImage(named: "icon show-hide", in: Bundle(for: LoginViewController.self), compatibleWith: nil),
                                                       invisibleIcon: hidePasswordImage ?? UIImage(named:  "icon hide", in: Bundle(for: LoginViewController.self), compatibleWith: nil))
        inputField.textValidationBlock = { [weak self] (text) -> Result<Void, Error> in
            guard let self = self else { return .success(()) }
            if !(text?.isEmpty ?? false) && ((text?.hasOnlySpace()) != nil)  {
                return .success(())
            } else {
                return .failure(ValidationError.wrongPassword)
            }
        }
        return inputField
    }()
    
    lazy var inputFieldGroup: HCInputFieldGroup = {
        let inputFieldGroup = HCInputFieldGroup(fields: [emailTextField, passwordTextField], shouldClearErrors: true, textFieldTextDidChange: { [self] text, inputField in
            if inputField == self.passwordTextField {
                if self.isValidText(text, regEx: .password) && !(text?.isEmpty ?? false) && ((text?.hasOnlySpace()) != nil) && !self.areAnyEmpty() {
                    self.isButtonEnabled = true
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
        }, completion: {
            // self.createButton.isEnabled = true
            print("Returned on the last cell")
        })
        return inputFieldGroup
    }()
    lazy var rememberMeSwitch: UISwitch = {
        let testSwitch = UISwitch()
        return testSwitch
    }()
    
    lazy var rememberMeLabel: UILabel = {
        let label = UILabel()
        label.text = rememberMeTitle ?? Constants.rememberMe
        label.textAlignment = .left
        return label
    }()
    
    lazy var enableFacaeIdSwitch: UISwitch = {
        let testSwitch = UISwitch()
        testSwitch.isOn = UserDefaults.standard.bool(forKey: "isBioMetricEnabled")
        return testSwitch
    }()
    
    lazy var enableFacaeIdLabel: UILabel = {
        let label = UILabel()
        label.text = enableFaceIdTitle ?? Constants.enableFaceId
        label.textAlignment = .left
        return label
    }()
    
    lazy var switchStakeView: UIStackView  = {
        let stackView = UIStackView(arrangedSubviews: [rememberMeSwitch,
                                                       rememberMeLabel,
                                                       enableFacaeIdSwitch,
                                                       enableFacaeIdLabel])
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 5
        view.addSubview(stackView)
        return stackView
    }()
    
    var isButtonEnabled: Bool = false {
        willSet(newValue) {
            if newValue {
                loginButton.isEnabled = true
            } else {
                loginButton.isEnabled = false
            }
        }
    }
    
    lazy var forgotPasswordButton: HCLinkButton = HCLinkButton(title: forgotPasswordTitle ?? Constants.forgotPassword)
    
    lazy var loginButton: HCButton = HCButton(title: loginButtonTitle ?? Constants.login, type: .filled)
    
    lazy var createAccountButton: HCButton = HCButton(title: createAccountButtonTitle ?? Constants.createAccount, type: .normal)
    
    lazy var continueAsGuestButton: HCLinkButton = HCLinkButton(title: continueAsGuestTitle ?? Constants.continueAsGuest)
    
    lazy var emptyView = UIView()
    
    lazy var stackView: UIStackView  = {
        let stackView = UIStackView(arrangedSubviews: [headerImageview,
                                                       titleLabel,
                                                       emailTextField,
                                                       passwordTextField,
                                                       switchStakeView,
                                                       forgotPasswordButton,
                                                       loginButton,
                                                       createAccountButton,
                                                       continueAsGuestButton,
                                                       emptyView])
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 15
        view.addSubview(stackView)
        return stackView
    }()
    
    let screenTitle: String?
    let emailTitle:  String?
    let passwordTitle:  String?
    let rememberMeTitle: String?
    let enableFaceIdTitle: String?
    let loginButtonTitle: String?
    let createAccountButtonTitle: String?
    let continueAsGuestTitle: String?
    let forgotPasswordTitle: String?
    let headerImage: UIImage?
    let showPasswordImage: UIImage?
    let hidePasswordImage: UIImage?
    
    weak var delegate: AddLoginButtonDidClickProtocol?
    
    public init(screenTitle: String?,
         emailFieldTitle: String?,
         passwordFieldTitle: String?,
         rememberMeTitle: String?,
         enableFaceIdTitle: String?,
         loginButtonTitle: String?,
         createAccountButtonTitle: String?,
         continueAsGuestTitle: String?,
         forgotPasswordTitle: String?,
         headerImage: UIImage?,
         showPasswordImage: UIImage?,
         hidePasswordImage: UIImage?) {
        self.screenTitle = screenTitle
        passwordTitle = passwordFieldTitle
        emailTitle = emailFieldTitle
        self.loginButtonTitle = loginButtonTitle
        self.createAccountButtonTitle = createAccountButtonTitle
        self.rememberMeTitle = rememberMeTitle
        self.enableFaceIdTitle = enableFaceIdTitle
        self.continueAsGuestTitle = continueAsGuestTitle
        self.forgotPasswordTitle = forgotPasswordTitle
        self.headerImage = headerImage
        self.showPasswordImage = showPasswordImage
        self.hidePasswordImage = hidePasswordImage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.Gray.backgroundlight
        inputFieldGroup.becomeFirstResponder()
        setupView()
    }
    
    private func setupView() {
        view.addSubview(scrollView)
        scrollView.addSubview(headerImageview)
        scrollView.addSubview(stackView)
        view.backgroundColor = .white
        setupConstraints()
        setActionEvent()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 44),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 20),
            headerImageview.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            headerImageview.heightAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.5),
            emailTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            switchStakeView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            loginButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            createAccountButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            switchStakeView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createAccountButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            emptyView.heightAnchor.constraint(greaterThanOrEqualToConstant: 10)
            
        ])
    }
    
    private func setActionEvent(){
        forgotPasswordButton.addAction {
            self.delegate?.addForgotPasswordButtonDidClick()
        }
        loginButton.addAction { [self] in
            if enableFacaeIdSwitch.isOn {
                self.dobiometric()
            } else {
                self.delegate?.addLoginButtonDidClick(email: emailTextField.textField.text ?? "", password: passwordTextField.textField.text ?? "", rememberme: rememberMeSwitch.isOn, enableFaceId: enableFacaeIdSwitch.isOn)
            }
        }
        createAccountButton.addAction {
            self.delegate?.addCreateAccountButtonDidClick()
        }
        continueAsGuestButton.addAction {
            self.delegate?.addContinueAsGuestButtonDidClick()
        }
    }
    
    private func isValidText(_ text: String?, regEx: ValidRegEx) -> Bool {
        guard let text = text else { return true }
        let regex = regEx.rawValue
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", regex)
        return emailPred.evaluate(with: text)
    }
    
    private func areAnyEmpty() -> Bool {
        for input in inputFieldGroup.fields {
            if input.textField.text?.isEmpty ?? false && ((input.textField.text?.hasOnlySpace()) != nil) {
                return true
            }
        }
        return false
    }
    
    
    func dobiometric() {
        LocalAuthenticationManager.authenticateBioMetrics(reason: "") { [weak self] (result) in
            switch result {
            case .success( _):
                UserDefaults.standard.set(true, forKey: "isBioMetricEnabled")
                self?.delegate?.addLoginButtonDidClick(email: self?.emailTextField.textField.text ?? "", password: self?.passwordTextField.textField.text ?? "", rememberme: self?.rememberMeSwitch.isOn ?? false, enableFaceId: self?.enableFacaeIdSwitch.isOn ?? false)
            case .failure(let error):
                switch error {
                case .biometricsNotEnrolled, .passcodeNotSet:
                    self?.showAuthenticationWarning(message: error.message())
                case .canceledByUser, .canceledBySystem:
                    break
                default:
                    UserDefaults.standard.set(false, forKey: "isBioMetricEnabled")
                }
            }
        }
    }

    func showAuthenticationWarning(message: String) {
        let alert = UIAlertController(
            title:  "Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(.init(title: "Settings", style: .default) {
            _ in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        })
        alert.addAction(.init(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }

    
}
