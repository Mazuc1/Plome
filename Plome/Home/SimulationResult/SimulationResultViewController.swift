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

    // MARK: - UI

    private let resultTitleLabel: UILabel = .init().configure {
        $0.text = "Félicitation !"
        $0.font = PlomeFont.demiBoldM.font
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.textColor = PlomeColor.darkBlue.color
    }

    private let resultImageView: UIImageView = .init().configure {
        $0.image = Icons.success.configure(weight: .regular, color: .success, size: 125)
    }

    private let admissionLabel: UILabel = .init().configure {
        $0.text = "Vous êtes admis"
        $0.font = PlomeFont.demiBoldM.font
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.textColor = PlomeColor.darkBlue.color
    }

    private let mentionLabel: UILabel = .init().configure {
        $0.text = "Mention bien"
        $0.font = PlomeFont.bodyM.font
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.textColor = PlomeColor.darkGray.color
    }

    private let finalGradeLabel: UILabel = .init().configure {
        $0.text = "20/20"
        $0.font = PlomeFont.demiBoldM.font
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.textColor = PlomeColor.darkBlue.color
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

        setupLayout()
    }

    // MARK: - Methods

    private func setupLayout() {
        let firstNumberCell = SomeNumberCell(frame: .zero, examTypeName: "Epreuves", grade: "17.30")
        let secondNumberCell = SomeNumberCell(frame: .zero, examTypeName: "Contrôle continue", grade: "17.30")
        let thirdNumberCell = SomeNumberCell(frame: .zero, examTypeName: "Options", grade: "17.30")

        someNumbersStackView.addArrangedSubviews([someNumbersLabel, firstNumberCell, secondNumberCell, thirdNumberCell])
        firstNumberCell.attachToSides(parentView: someNumbersStackView)
        secondNumberCell.attachToSides(parentView: someNumbersStackView)
        thirdNumberCell.attachToSides(parentView: someNumbersStackView)

        ctaStackView.addArrangedSubviews([primaryCTARemakeSimulation, secondaryCTASaveModel])
        primaryCTARemakeSimulation.attachToSides(parentView: ctaStackView)
        secondaryCTASaveModel.attachToSides(parentView: ctaStackView)

        resultInformationsStackView.addArrangedSubviews([admissionLabel, mentionLabel, finalGradeLabel])
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
    }

    @objc private func userDidTapRemakeSimulation() {}
    @objc private func userDidTapSaveModel() {}
}

class SomeNumberCell: UIView {
    // MARK: - Properties

    let examTypeName: String
    let grade: String

    // MARK: - UI

    private let examTypeNameLabel: UILabel = .init().configure {
        $0.font = PlomeFont.bodyM.font
        $0.textColor = PlomeColor.darkBlue.color
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }

    private let gradeLabel: UILabel = .init().configure {
        $0.font = PlomeFont.bodyM.font
        $0.textColor = PlomeColor.darkGray.color
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }

    private let stackView: UIStackView = .init().configure {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.spacing = AppStyles.defaultSpacing
        $0.alignment = .leading
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isLayoutMarginsRelativeArrangement = true
    }

    // MARK: - Init

    required init(frame: CGRect, examTypeName: String, grade: String) {
        self.grade = grade
        self.examTypeName = examTypeName

        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        grade = ""
        examTypeName = ""

        super.init(coder: aDecoder)
        setupView()
    }

    // MARK: - Methods

    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false

        backgroundColor = .white
        layer.cornerRadius = AppStyles.defaultRadius

        examTypeNameLabel.text = examTypeName
        gradeLabel.text = "\(grade)/20"

        stackView.addArrangedSubviews([examTypeNameLabel, UIView(), gradeLabel])
        stackView.stretchInView(parentView: self)

        stackView.layoutMargins = .init(top: AppStyles.defaultSpacing,
                                        left: AppStyles.defaultSpacing,
                                        bottom: AppStyles.defaultSpacing,
                                        right: AppStyles.defaultSpacing)
    }
}
