//
//  LoadingViewController.swift
//  PineappleCoreKit
//
//  Created by Loïc MAZUC on 12/08/2022.
//

import UIKit

public final class LoadingViewController: UIViewController {
    var loadingActivityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()

        indicator.style = .large
        indicator.color = .white

        indicator.startAnimating()

        indicator.autoresizingMask = [
            .flexibleLeftMargin, .flexibleRightMargin,
            .flexibleTopMargin, .flexibleBottomMargin,
        ]

        return indicator
    }()

    var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)

        blurEffectView.alpha = 0.2

        blurEffectView.autoresizingMask = [
            .flexibleWidth, .flexibleHeight,
        ]

        return blurEffectView
    }()

    override public func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)

        blurEffectView.frame = view.bounds
        view.insertSubview(blurEffectView, at: 0)

        // Add the loadingActivityIndicator in the
        // center of view
        loadingActivityIndicator.center = CGPoint(
            x: view.bounds.midX,
            y: view.bounds.midY
        )
        view.addSubview(loadingActivityIndicator)
    }
}
