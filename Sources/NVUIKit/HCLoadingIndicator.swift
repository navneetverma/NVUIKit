//
//  LoadingIndicator.swift
//  HealthcareIP
//
//  Created by Jigar.Patel on 3/16/22.
//

import UIKit

extension UIView {
    public func showLoadingIndicator(blurEffectStyle:UIBlurEffect.Style, indicatorStyle: UIActivityIndicatorView.Style, indicatorColor: UIColor) {
        let loadingIndicator = HCLoadingIndicator(frame: frame, blurEffectStyle: blurEffectStyle, indicatorStyle: indicatorStyle, indicatorColor: indicatorColor)
        self.addSubview(loadingIndicator)
    }

    public func removeLoadingIndicator() {
        if let loadingIndicator = subviews.first(where: { $0 is HCLoadingIndicator }) {
            loadingIndicator.removeFromSuperview()
        }
    }
}


public class HCLoadingIndicator: UIView {

    var blurEffectView: UIVisualEffectView?

    init(frame: CGRect, blurEffectStyle:UIBlurEffect.Style, indicatorStyle: UIActivityIndicatorView.Style, indicatorColor: UIColor) {
        let blurEffect = UIBlurEffect(style: blurEffectStyle)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = frame
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.blurEffectView = blurEffectView
        super.init(frame: frame)
        addSubview(blurEffectView)
        addLoader(indicatorStyle: indicatorStyle, indicatorColor: indicatorColor)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addLoader(indicatorStyle: UIActivityIndicatorView.Style, indicatorColor: UIColor) {
        guard let blurEffectView = blurEffectView else { return }
        let activityIndicator = UIActivityIndicatorView(style: indicatorStyle)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        blurEffectView.contentView.addSubview(activityIndicator)
        activityIndicator.center = blurEffectView.contentView.center
        activityIndicator.color = indicatorColor
        activityIndicator.startAnimating()
    }
}
