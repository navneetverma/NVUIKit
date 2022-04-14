//
//  HCTestResultDetailViewController.swift
//  HealthcareIP
//
//  Created by Jigar.Patel on 4/5/22.
//

import UIKit
import Foundation

protocol AddTestResultDetailButtonDidClickProtocol: AnyObject {
    func addViewFullDetailButtonDidClick()
    func addCloseButtonDidClick()
}

public class HCTestResultDetailViewController: UIViewController {

    @IBOutlet weak public var containerView: UIView!
    @IBOutlet weak public var cancelButton: UIButton!
    @IBOutlet weak public var titleLabel: UILabel!
    @IBOutlet weak public var titleSeparatorView: UIView!
    @IBOutlet weak public var testResultTitle1: UILabel!
    @IBOutlet weak public var testResultDetail1: UILabel!
    @IBOutlet weak public var testResultTitle2: UILabel!
    @IBOutlet weak public var testResultDetail2: UILabel!
    @IBOutlet weak public var testResultTitle3: UILabel!
    @IBOutlet weak public var testResultDetail3: UILabel!
    @IBOutlet weak public var testResultTitle4: UILabel!
    @IBOutlet weak public var testResultDetail4: UILabel!
    @IBOutlet weak public var testResultTitle5: UILabel!
    @IBOutlet weak public var testResultDetail5: UILabel!
    @IBOutlet weak public var viewFullDetailButton: HCLinkButton!
    @IBOutlet weak public var viewFullDetailImageView: UIImageView!
    @IBOutlet weak public var closeButton: HCButton!
    
    weak var delegate: AddTestResultDetailButtonDidClickProtocol?
    
    private enum Constants {
        static let title = "TestResultDetail.title".localized()
        static let testResultTitle1 = "TestResultDetail.title1".localized()
        static let testResultDetail1 = "TestResultDetail.detail1".localized()
        static let testResultTitle2 = "TestResultDetail.title2".localized()
        static let testResultDetail2 = "TestResultDetail.detail2".localized()
        static let testResultTitle3 = "TestResultDetail.title3".localized()
        static let testResultDetail3 = "TestResultDetail.detail3".localized()
        static let testResultTitle4 = "TestResultDetail.title4".localized()
        static let testResultDetail4 = "TestResultDetail.detail4".localized()
        static let testResultTitle5 = "TestResultDetail.title5".localized()
        static let testResultDetail5 = "TestResultDetail.detail5".localized()
        static let viewFullDetailButtonTitle = "TestResultDetail.viewFullDetailButtonTitle".localized()
        static let closeButtonTitle = "TestResultDetail.closeButtonTitle".localized()
    }
    
    public init() {
        super.init(nibName: "HCTestResultDetailViewController", bundle: Bundle(for: HCTestResultDetailViewController.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        self.titleLabel.text = Constants.title
        self.testResultTitle1.text = Constants.testResultTitle1
        self.testResultDetail1.text = Constants.testResultDetail1
        self.testResultTitle2.text = Constants.testResultTitle2
        self.testResultDetail2.text = Constants.testResultDetail2
        self.testResultTitle3.text = Constants.testResultTitle3
        self.testResultDetail3.text = Constants.testResultDetail3
        self.testResultTitle4.text = Constants.testResultTitle4
        self.testResultDetail4.text = Constants.testResultDetail4
        self.testResultTitle5.text = Constants.testResultTitle5
        self.testResultDetail5.text = Constants.testResultDetail5
        self.viewFullDetailButton.setTitle(Constants.viewFullDetailButtonTitle, for: .normal)
        self.viewFullDetailButton.setTitleColor(UIColor.Blue.mitchell, for: .normal)
        self.closeButton.setTitle(Constants.closeButtonTitle, for: .normal)
        self.closeButton.setStyle(type: HCButton.ButtonType.filled)
        
        self.containerView.layer.cornerRadius = 15
        self.containerView.clipsToBounds = true
        
        viewFullDetailButton.addAction {
            self.delegate?.addViewFullDetailButtonDidClick()
        }
        
        closeButton.addAction {
            self.delegate?.addCloseButtonDidClick()
        }
        self.view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        
    }

}
