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

    private let resultStackView: UIStackView = .init().configure {
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
        $0.distribution = .equalSpacing
        $0.spacing = AppStyles.defaultSpacing(factor: 2)
        $0.alignment = .center
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private let stackView: UIStackView = .init().configure {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.spacing = AppStyles.defaultSpacing(factor: 2)
        $0.alignment = .center
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
        someNumbersStackView.addArrangedSubviews([someNumbersLabel,
                                                  SomeNumberCell(frame: .zero, examTypeName: "Examen", grade: "17.30"),
                                                  SomeNumberCell(frame: .zero, examTypeName: "Examen", grade: "17.30"),
                                                  SomeNumberCell(frame: .zero, examTypeName: "Examen", grade: "17.30")])

        resultStackView.addArrangedSubviews([admissionLabel, mentionLabel, finalGradeLabel])
        stackView.addArrangedSubviews([resultTitleLabel, resultImageView, resultStackView, someNumbersStackView])

        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])

        stackView.attachToSides(parentView: view)
        resultStackView.attachToSides(parentView: stackView)

        resultStackView.layoutMargins = .init(top: AppStyles.defaultSpacing,
                                              left: AppStyles.defaultSpacing,
                                              bottom: AppStyles.defaultSpacing,
                                              right: AppStyles.defaultSpacing)
    }
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
        $0.distribution = .fill
        $0.spacing = AppStyles.defaultSpacing(factor: 2)
        $0.alignment = .center
        $0.translatesAutoresizingMaskIntoConstraints = false
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

        stackView.addArrangedSubviews([examTypeNameLabel, gradeLabel])
        stackView.stretchInView(parentView: self)
    }
}
