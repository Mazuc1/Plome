//
//  SimulationResultViewController.swift
//  Plome
//
//  Created by Loic Mazuc on 10/11/2022.
//

import PlomeCoreKit
import UIKit

final class SimulationResultViewController: AppViewController {
    // MARK: - Properties

    let viewModel: SimulationResultViewModel

    private static let succeessImage: UIImage = Icons.success.configure(weight: .regular, color: .success, size: 125)
    private static let failureImage: UIImage = Icons.fail.configure(weight: .regular, color: .fail, size: 125)
    private var scrollViewWidth: CGFloat = 100

    // MARK: - UI

    private let resultTitleLabel: AppLabel = .init(withInsets: AppStyles.defaultSpacing(factor: 2), 0, 0, 0).configure {
        $0.font = PlomeFont.demiBoldM.font
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.textColor = PlomeColor.darkBlue.color
    }

    private let resultImageView: UIImageView = .init().configure {
        $0.image = Icons.success.configure(weight: .regular, color: .success, size: 125)
    }

    private let admissionLabel: UILabel = .init().configure {
        $0.font = PlomeFont.demiBoldM.font
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.textColor = PlomeColor.darkBlue.color
    }

    private let mentionLabel: UILabel = .init().configure {
        $0.font = PlomeFont.bodyM.font
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.textColor = PlomeColor.darkGray.color
    }

    private let finalGradeLabel: UILabel = .init().configure {
        $0.font = PlomeFont.demiBoldM.font
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.textColor = PlomeColor.darkBlue.color
    }

    private let finalGradeBeforeTwentyConformLabel: UILabel = .init().configure {
        $0.font = PlomeFont.bodyS.font
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.textColor = PlomeColor.darkGray.color
    }

    private let resultInformationsStackView: UIStackView = .init().configure {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = AppStyles.defaultSpacing
        $0.alignment = .center
        $0.isLayoutMarginsRelativeArrangement = true
        $0.backgroundColor = .white
        $0.layer.cornerRadius = AppStyles.defaultRadius
        $0.addShadow(color: PlomeColor.darkGray.color, offset: .init(width: 3, height: 3), opacity: 0.2)
        $0.layoutMargins = .init(top: AppStyles.defaultSpacing,
                                 left: AppStyles.defaultSpacing,
                                 bottom: AppStyles.defaultSpacing,
                                 right: AppStyles.defaultSpacing)
    }

    private let someNumbersLabel: UILabel = .init().configure {
        $0.text = L10n.Home.someNumbers
        $0.font = PlomeFont.demiBoldM.font
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.textColor = PlomeColor.darkBlue.color
    }

    private let someNumbersStackView: UIStackView = .init().configure {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = AppStyles.defaultSpacing
        $0.alignment = .leading
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private lazy var primaryCTARemakeSimulation: PrimaryCTA = .init(title: L10n.Home.remakeSimulation).configure { [weak self] in
        $0.addTarget(self, action: #selector(userDidTapRemakeSimulation), for: .touchUpInside)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private lazy var tertiaryCTABackToHome: TertiaryCTA = .init(title: L10n.Home.returnToHome).configure { [weak self] in
        $0.addTarget(self, action: #selector(userDidTapBackToHome), for: .touchUpInside)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private let ctaStackView: UIStackView = .init().configure {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = AppStyles.defaultSpacing(factor: 2)
        $0.alignment = .center
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private let resultStackView: UIStackView = .init().configure {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = AppStyles.defaultSpacing(factor: 2)
        $0.alignment = .center
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private let screenshotStackView: UIStackView = .init().configure {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = AppStyles.defaultSpacing(factor: 2)
        $0.alignment = .center
    }

    private let scrollViewContainerStackView: UIStackView = .init().configure {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = AppStyles.defaultSpacing(factor: 7)
        $0.alignment = .center
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isBaselineRelativeArrangement = true
        let spacing = AppStyles.defaultSpacing(factor: 2)
        $0.layoutMargins = .init(top: spacing, left: spacing, bottom: spacing, right: spacing)
    }

    private let scrollView: UIScrollView = .init().configure {
        $0.showsVerticalScrollIndicator = false
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private lazy var confettiView: ConfettiView = .init(frame: self.view.bounds, colors: PlomeColor.confettiColors)

    // MARK: - Init

    required init(viewModel: SimulationResultViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollViewWidth = view.frame.width - AppStyles.defaultSpacing(factor: 4)

        navigationItem.title = L10n.Home.result
        navigationItem.rightBarButtonItem = createShareResultBarButton()

        viewModel.save()

        setCalculatorInformation()
        setupLayout()
    }

    // MARK: - Methods

    private func setCalculatorInformation() {
        finalGradeLabel.text = viewModel.shaper.finalGradeOutOfTwenty()

        if viewModel.shaper.hasSucceedExam() {
            resultImageView.image = Self.succeessImage
            confettiView.startConfetti()
        } else {
            resultImageView.image = Self.failureImage
        }

        admissionLabel.text = viewModel.shaper.admissionSentence()
        resultTitleLabel.text = viewModel.shaper.resultSentence()
        mentionLabel.text = viewModel.shaper.mentionSentence()
        finalGradeBeforeTwentyConformLabel.text = viewModel.shaper.finalGradeBeforeTwentyConform()
    }

    private func setupLayout() {
        createSomeNumbersView()

        ctaStackView.addArrangedSubview(primaryCTARemakeSimulation)
        if !isModal { ctaStackView.addArrangedSubview(tertiaryCTABackToHome) }
        ctaStackView.setWidthConstraint(constant: scrollViewWidth)

        resultInformationsStackView.addArrangedSubviews([admissionLabel, finalGradeLabel, finalGradeBeforeTwentyConformLabel])

        if viewModel.shaper.hasSucceedExam() {
            resultInformationsStackView.insertArrangedSubview(mentionLabel, at: 1)
        }

        screenshotStackView.addArrangedSubviews([resultTitleLabel, resultImageView, resultInformationsStackView])
        resultStackView.addArrangedSubviews([screenshotStackView, someNumbersStackView])

        if viewModel.shaper.displayCatchUpSectionIfNeeded() {
            guard let catchUpView = createCatchUpView() else { return }
            resultStackView.addArrangedSubview(catchUpView)
        }

        scrollViewContainerStackView.addArrangedSubviews([resultStackView, ctaStackView])
        scrollViewContainerStackView.stretchInView(parentView: scrollView)

        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            resultStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1),
            primaryCTARemakeSimulation.heightAnchor.constraint(equalToConstant: AppStyles.primaryCTAHeight),
        ])

        resultStackView.addSubview(confettiView)
    }

    private func createSomeNumbersView() {
        var views: [UIView] = []

        if viewModel.shaper.simulationContainTrials() {
            views.append(GradeInformationCell(frame: .zero, title: PlomeCoreKit.L10n.trialsType, grade: viewModel.shaper.trialsGrade()))
        }

        if viewModel.shaper.simulationContainContinousControls() {
            views.append(GradeInformationCell(frame: .zero, title: PlomeCoreKit.L10n.continuousControlsType, grade: viewModel.shaper.continousControlGrade()))
        }

        if viewModel.shaper.simulationContainOptions() {
            views.append(GradeInformationCell(frame: .zero, title: PlomeCoreKit.L10n.optionsType, grade: viewModel.shaper.optionGrade()))
        }

        someNumbersStackView.addArrangedSubview(someNumbersLabel)
        someNumbersStackView.addArrangedSubviews(views)
        someNumbersStackView.setWidthConstraint(constant: scrollViewWidth)
    }

    private func createCatchUpView() -> UIView? {
        guard let catchUpInformations = viewModel.shaper.getCatchUpInformations() else { return nil }
        return CatchUpView(frame: .zero, grade: catchUpInformations.grade, differenceAfterCatchUp: catchUpInformations.difference)
    }

    private func createShareResultBarButton() -> UIBarButtonItem {
        UIBarButtonItem(image: Icons.share.configure(weight: .regular, color: .lagoon, size: 16), style: .plain, target: self, action: #selector(userDidTapShareResult))
    }

    @objc private func userDidTapRemakeSimulation() {
        viewModel.userDidTapRemakeSimulate()
    }

    @objc private func userDidTapShareResult() {
        viewModel.userDidTapShareResult(screenshot: screenshotStackView.takeScreenshot())
    }

    @objc private func userDidTapBackToHome() {
        viewModel.userDidTapBackToHome()
    }
}
