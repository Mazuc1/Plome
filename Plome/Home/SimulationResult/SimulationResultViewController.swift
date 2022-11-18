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

    // MARK: - UI

    private let resultTitleLabel: UILabel = .init().configure {
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
        $0.distribution = .equalCentering
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
        $0.distribution = .equalCentering
        $0.spacing = AppStyles.defaultSpacing
        $0.alignment = .center
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private lazy var primaryCTARemakeSimulation: PrimaryCTA = .init(title: "Refaire une simulation").configure { [weak self] in
        $0.addTarget(self, action: #selector(userDidTapRemakeSimulation), for: .touchUpInside)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private lazy var secondaryCTASaveModel: SecondaryCTA = .init(title: "Enregistrer ce modèle").configure { [weak self] in
        $0.addTarget(self, action: #selector(userDidTapSaveModel), for: .touchUpInside)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private let ctaStackView: UIStackView = .init().configure {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.spacing = AppStyles.defaultSpacing(factor: 2)
        $0.alignment = .center
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private let resultStackView: UIStackView = .init().configure {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.spacing = AppStyles.defaultSpacing(factor: 2)
        $0.alignment = .center
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private let scrollViewContainerStackView: UIStackView = .init().configure {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.spacing = AppStyles.defaultSpacing(factor: 7)
        $0.alignment = .center
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private let scrollView: UIScrollView = .init().configure {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private lazy var confettiView: ConfettiView = .init(frame: self.view.bounds).configure {
        $0.intensity = 0.5
        $0.colors = [PlomeColor.success.color,
                     PlomeColor.success.color.withAlphaComponent(0.6),
                     PlomeColor.success.color.withAlphaComponent(0.2)]
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
        navigationItem.title = "Résultat"

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

        ctaStackView.addArrangedSubviews([primaryCTARemakeSimulation, secondaryCTASaveModel])
        primaryCTARemakeSimulation.attachToSides(parentView: ctaStackView)
        secondaryCTASaveModel.attachToSides(parentView: ctaStackView)

        resultInformationsStackView.addArrangedSubviews([admissionLabel, finalGradeLabel, finalGradeBeforeTwentyConformLabel])
        if viewModel.hasSucceedExam() {
            resultInformationsStackView.insertArrangedSubview(mentionLabel, at: 1)
        }

        resultStackView.addArrangedSubviews([resultTitleLabel, resultImageView, resultInformationsStackView, someNumbersStackView])

        resultInformationsStackView.attachToSides(parentView: resultStackView)
        someNumbersStackView.attachToSides(parentView: resultStackView)
        ctaStackView.attachToSides(parentView: resultStackView)

        resultInformationsStackView.layoutMargins = .init(top: AppStyles.defaultSpacing,
                                                          left: AppStyles.defaultSpacing,
                                                          bottom: AppStyles.defaultSpacing,
                                                          right: AppStyles.defaultSpacing)

        scrollViewContainerStackView.addArrangedSubviews([resultStackView, ctaStackView])

        scrollView.addSubview(scrollViewContainerStackView)
        scrollViewContainerStackView.stretchInView(parentView: scrollView)

        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            resultStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: AppStyles.defaultSpacing(factor: 2)),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: AppStyles.defaultSpacing(factor: 2)),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AppStyles.defaultSpacing(factor: 2)),
            view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: AppStyles.defaultSpacing(factor: 2)),
            primaryCTARemakeSimulation.heightAnchor.constraint(equalToConstant: AppStyles.primaryCTAHeight),
            secondaryCTASaveModel.heightAnchor.constraint(equalToConstant: AppStyles.secondaryCTAHeight),
        ])

        view.addSubview(confettiView)
    }

    private func createSomeNumbersView() {
        var views: [UIView] = []

        if viewModel.simulationContainTrials() {
            views.append(SomeNumberCell(frame: .zero, examTypeName: "Epreuves", grade: viewModel.trialsGrade()))
        }

        if viewModel.simulationContainContinousControls() {
            views.append(SomeNumberCell(frame: .zero, examTypeName: "Contrôle continue", grade: viewModel.continousControlGrade()))
        }

        if viewModel.simulationContainOptions() {
            views.append(SomeNumberCell(frame: .zero, examTypeName: "Options", grade: viewModel.optionGrade()))
        }

        someNumbersStackView.addArrangedSubview(someNumbersLabel)
        someNumbersStackView.addArrangedSubviews(views)

        views.forEach { $0.attachToSides(parentView: someNumbersStackView) }
    }

    @objc private func userDidTapRemakeSimulation() {}
    @objc private func userDidTapSaveModel() {}
}
