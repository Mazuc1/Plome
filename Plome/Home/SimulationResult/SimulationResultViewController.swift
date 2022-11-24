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
        $0.text = "20/20"
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
    }

    private let someNumbersLabel: UILabel = .init().configure {
        $0.text = "Quelques chiffres"
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

    private lazy var primaryCTARemakeSimulation: PrimaryCTA = .init(title: "Refaire une simulation").configure { [weak self] in
        $0.addTarget(self, action: #selector(userDidTapRemakeSimulation), for: .touchUpInside)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private let saveModelLabel: UILabel = .init().configure {
        $0.text = "Vous avez modifié le modèle utilisé ? Pensez à l'enregistrer."
        $0.font = PlomeFont.bodyS.font
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.textColor = PlomeColor.darkGray.color
    }

    private lazy var tertiaryCTASaveModel: TertiaryCTA = .init(title: "Enregistrer ce modèle").configure { [weak self] in
        $0.addTarget(self, action: #selector(userDidTapSaveModel), for: .touchUpInside)
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
    }

    private let scrollView: UIScrollView = .init().configure {
        $0.showsVerticalScrollIndicator = false
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private lazy var confettiView: ConfettiView = .init(frame: self.view.bounds).configure {
        $0.intensity = 0.5
        $0.colors = PlomeColor.confettiColors
    }

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
        viewModel.calculator.calculate()

        scrollViewWidth = view.frame.width - AppStyles.defaultSpacing(factor: 4)
        navigationItem.title = "Résultat"
        navigationItem.rightBarButtonItem = createShareResultBarButton()

        viewModel.save(.simulation)

        setCalculatorInformation()
        setupLayout()
    }

    // MARK: - Methods

    private func setCalculatorInformation() {
        finalGradeLabel.text = viewModel.finalGradeOutOfTwenty()

        if viewModel.hasSucceedExam() {
            resultImageView.image = Self.succeessImage
            confettiView.startConfetti()
        } else {
            resultImageView.image = Self.failureImage
        }

        admissionLabel.text = viewModel.admissionSentence()
        resultTitleLabel.text = viewModel.resultSentence()
        mentionLabel.text = viewModel.mentionSentence()
        finalGradeBeforeTwentyConformLabel.text = viewModel.finalGradeBeforeTwentyConform()
    }

    private func setupLayout() {
        createSomeNumbersView()

        ctaStackView.addArrangedSubviews([primaryCTARemakeSimulation, saveModelLabel, tertiaryCTASaveModel])
        ctaStackView.setWidthConstraint(constant: scrollViewWidth)

        resultInformationsStackView.addArrangedSubviews([admissionLabel, finalGradeLabel, finalGradeBeforeTwentyConformLabel])

        if viewModel.hasSucceedExam() {
            resultInformationsStackView.insertArrangedSubview(mentionLabel, at: 1)
        }

        screenshotStackView.addArrangedSubviews([resultTitleLabel, resultImageView, resultInformationsStackView])
        resultStackView.addArrangedSubviews([screenshotStackView, someNumbersStackView])

        if viewModel.displayCatchUpSectionIfNeeded() {
            guard let catchUpView = createCatchUpView() else { return }
            resultStackView.addArrangedSubview(catchUpView)
        }

        resultInformationsStackView.layoutMargins = .init(top: AppStyles.defaultSpacing,
                                                          left: AppStyles.defaultSpacing,
                                                          bottom: AppStyles.defaultSpacing,
                                                          right: AppStyles.defaultSpacing)

        scrollViewContainerStackView.addArrangedSubviews([resultStackView, ctaStackView])
        scrollViewContainerStackView.stretchInView(parentView: scrollView)

        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AppStyles.defaultSpacing(factor: 2)),
            view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: AppStyles.defaultSpacing(factor: 2)),
            resultStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1),
            primaryCTARemakeSimulation.heightAnchor.constraint(equalToConstant: AppStyles.primaryCTAHeight),
            tertiaryCTASaveModel.heightAnchor.constraint(equalToConstant: AppStyles.tertiaryCTAHeight),
        ])

        resultStackView.addSubview(confettiView)
    }

    private func createSomeNumbersView() {
        var views: [UIView] = []

        if viewModel.simulationContainTrials() {
            views.append(GradeInformationCell(frame: .zero, title: "Epreuves", grade: viewModel.trialsGrade()))
        }

        if viewModel.simulationContainContinousControls() {
            views.append(GradeInformationCell(frame: .zero, title: "Contrôle continue", grade: viewModel.continousControlGrade()))
        }

        if viewModel.simulationContainOptions() {
            views.append(GradeInformationCell(frame: .zero, title: "Options", grade: viewModel.optionGrade()))
        }

        someNumbersStackView.addArrangedSubview(someNumbersLabel)
        someNumbersStackView.addArrangedSubviews(views)
        someNumbersStackView.setWidthConstraint(constant: scrollViewWidth)
    }

    private func createCatchUpView() -> UIView? {
        guard let catchUpInformations = viewModel.getCatchUpInformations() else { return nil }
        return CatchUpView(frame: .zero, grade: catchUpInformations.grade, differenceAfterCatchUp: catchUpInformations.difference)
    }

    private func createShareResultBarButton() -> UIBarButtonItem {
        UIBarButtonItem(image: Icons.share.configure(weight: .regular, color: .pink, size: 20), style: .plain, target: self, action: #selector(userDidTapShareResult))
    }

    @objc private func userDidTapRemakeSimulation() {
        viewModel.userDidTapRemakeSimulate()
    }

    @objc private func userDidTapSaveModel() {
        viewModel.save(.simulationModel)
    }

    @objc private func userDidTapShareResult() {
        viewModel.userDidTapShareResult(screenshot: screenshotStackView.takeScreenshot())
    }
}
