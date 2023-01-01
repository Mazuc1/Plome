//
//  AppViewController.swift
//  PlomeCoreKit
//
//  Created by Loic Mazuc on 09/10/2022.
//

import UIKit

open class AppViewController: UIViewController {
    
    // MARK: - Properties
    
    private var loadingVC: LoadingViewController?
    
    // MARK: - Life cycle
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = PlomeColor.background.color
    }
    
    // MARK: - Methods
    
    public func showLoader() {
        if loadingVC == nil { createLoadingVC() }
        
        if let loadingVC {
            present(loadingVC, animated: true, completion: nil)
        }
    }
    
    public func dismissLoader() {
        loadingVC?.dismiss(animated: true)
    }
    
    private func createLoadingVC() {
        loadingVC = .init().configure {
            $0.modalPresentationStyle = .overCurrentContext
            $0.modalTransitionStyle = .crossDissolve
        }
    }
}
