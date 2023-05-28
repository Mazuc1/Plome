//
//  TaskLoaderManager.swift
//  Gateway
//
//  Created by Loic Mazuc on 01/01/2023.
//

import Foundation
import UIKit

@MainActor
public class TaskLoaderManager {
    // MARK: - Properties

    public static let shared = TaskLoaderManager()

    private weak var rootViewController: UIViewController?

    let taskLoaderView = TaskLoaderView(frame: .zero)

    /// Needed for testing purpose
    private let subsituteViewController = UIViewController()

    // MARK: - Init

    init() {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        rootViewController = windowScene?.windows.last?.rootViewController ?? subsituteViewController
    }

    // MARK: - Methods

    public func addTask() {
        guard let rootViewController else { return }

        taskLoaderView.activityIndicator.startAnimating()

        rootViewController.view.addSubview(taskLoaderView)
        rootViewController.view.bringSubviewToFront(taskLoaderView)

        NSLayoutConstraint.activate([
            taskLoaderView.topAnchor.constraint(equalTo: rootViewController.view.topAnchor),
            taskLoaderView.leadingAnchor.constraint(equalTo: rootViewController.view.leadingAnchor),
            rootViewController.view.bottomAnchor.constraint(equalTo: taskLoaderView.bottomAnchor),
            rootViewController.view.trailingAnchor.constraint(equalTo: taskLoaderView.trailingAnchor),
        ])
    }

    public func endTask() {
        taskLoaderView.removeFromSuperview()
        taskLoaderView.activityIndicator.stopAnimating()
    }
}

class TaskLoaderView: UIView {
    // MARK: - Properties

    let activityIndicator = UIActivityIndicatorView(style: .medium)

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Method

    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .black.withAlphaComponent(0.2)

        addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
