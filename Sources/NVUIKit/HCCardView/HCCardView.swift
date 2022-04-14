//
//  HCCardView.swift
//  HealthcareIP
//
//  Created by Jigar.Patel on 3/3/22.
//

import UIKit
protocol AddCardViewButtonDidClickProtocol: AnyObject {
    func addLocatonButtonDidClick()
    func addSaveButtonDidClick()

}
public class HCCardView: UIView {
    
    @IBOutlet weak public var cardImageView: UIImageView!
    @IBOutlet weak public var covidView: UIView!
    @IBOutlet weak public var covidLabel: UILabel!
    @IBOutlet weak public var covidImageView: UIImageView!
    @IBOutlet weak public var titleLabel: UILabel!
    @IBOutlet weak public var starImageView: UIImageView!
    @IBOutlet weak public var ratingsLabel: UILabel!
    @IBOutlet weak public var distanceLabel: UILabel!
    @IBOutlet weak public var locationImageView: UIImageView!
    @IBOutlet weak public var addressLinkButton: HCLinkButton!
    @IBOutlet weak public var beSeenLabel: UILabel!
    @IBOutlet weak public var timeLabel: UILabel!
    @IBOutlet weak public var saveButton: HCButton!
    
    weak var delegate: AddCardViewButtonDidClickProtocol?
    
    let nibName = "HCCardView"

    private enum Constants {
        static let title = "CardView.title".localized()
        static let covidTitle = "CardView.covidTitle".localized()
        static let ratings = "CardView.ratings".localized()
        static let distance = "CardView.distance".localized()
        static let location = "CardView.location".localized()
        static let beSeenTitle = "CardView.beSeenTitle".localized()
        static let time = "CardView.time".localized()
        static let saveButtonTitle = "CardView.saveButtonTitle".localized()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        
        layer.cornerRadius = 15
        clipsToBounds = true
        
        covidView.layer.cornerRadius = 5
        covidView.clipsToBounds = true
        
        saveButton.setTitle(Constants.saveButtonTitle, for: .normal)
        saveButton.titleLabel?.font = .boldSystemFont(ofSize: 15)
        saveButton.setStyle(type: .filled)
        
        covidLabel.tintColor = UIColor.Gray.dark
        distanceLabel.tintColor = UIColor.Gray.dark

        covidLabel.text = Constants.covidTitle
        titleLabel.text = Constants.title
        ratingsLabel.text = Constants.ratings
        distanceLabel.text = Constants.distance
        beSeenLabel.text = Constants.beSeenTitle
        timeLabel.text = Constants.time
        
        addressLinkButton.setTitleColor(UIColor.black, for: .normal)
        addressLinkButton.setTitle(Constants.location, for: .normal)
        addressLinkButton.underline()
        
        addressLinkButton.addAction {
            self.delegate?.addLocatonButtonDidClick()
        }
        
        saveButton.addAction {
            self.delegate?.addSaveButtonDidClick()
        }
    }
    
    func loadViewFromNib() -> UIView? {
        let nibName = String(describing: type(of: self))
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil)[0] as? UIView
    }
    
}
