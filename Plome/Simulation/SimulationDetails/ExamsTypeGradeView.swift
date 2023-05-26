//
//  ExamsTypeGradeView.swift
//  Plome
//
//  Created by Loic Mazuc on 24/11/2022.
//

import PlomeCoreKit
import UIKit

final class ExamsTypeGradeView: UIView {
    // MARK: - Properties

    private let shaper: CalculatorShaper

    private static let progressRingsSize: [CGSize] = [
        .init(width: 150, height: 150),
        .init(width: 110, height: 110),
        .init(width: 70, height: 70),
    ]

    // MARK: - UI

    private var trialsProgressRing: ALProgressRing = .init().configure {
        $0.startColor = PlomeColor.trials.color
        $0.endColor = PlomeColor.trials.color
        $0.lineWidth = 10
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private var continuousControlProgressRing: ALProgressRing = .init().configure {
        $0.startColor = PlomeColor.continuousControl.color
        $0.endColor = PlomeColor.continuousControl.color
        $0.lineWidth = 10
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private var optionsProgressRing: ALProgressRing = .init().configure {
        $0.startColor = PlomeColor.options.color
        $0.endColor = PlomeColor.options.color
        $0.lineWidth = 10
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private let stackView: UIStackView = .init().configure {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.spacing = AppStyles.defaultSpacing
        $0.alignment = .center
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = .init(top: AppStyles.defaultSpacing,
                                 left: AppStyles.defaultSpacing,
                                 bottom: AppStyles.defaultSpacing,
                                 right: AppStyles.defaultSpacing)
    }

    // MARK: - Init

    required init(frame: CGRect, shaper: CalculatorShaper) {
        self.shaper = shaper

        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        shaper = .init(calculator: .init(simulation: .init(name: "", date: nil, exams: nil, type: .custom)))

        super.init(coder: aDecoder)
        setupView()
    }

    // MARK: - Methods

    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false

        backgroundColor = .white
        layer.cornerRadius = AppStyles.defaultRadius

        let progressViews = setupProgressViews()
        stackView.addArrangedSubviews([setupInformationsProgressViews(), progressViews])

        NSLayoutConstraint.activate([
            progressViews.widthAnchor.constraint(equalToConstant: Self.progressRingsSize[0].width),
            progressViews.heightAnchor.constraint(equalToConstant: Self.progressRingsSize[0].height),
        ])

        stackView.stretchInView(parentView: self)
    }

    private func setupProgressViews() -> UIView {
        let view: UIView = .init().configure {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        var index = 0

        if shaper.simulationContainTrials(),
           let progress = shaper.trialsGradeProgress()
        {
            trialsProgressRing.setProgress(progress, animated: true)
            view.addSubview(trialsProgressRing)

            NSLayoutConstraint.activate([
                trialsProgressRing.widthAnchor.constraint(equalToConstant: Self.progressRingsSize[index].width),
                trialsProgressRing.heightAnchor.constraint(equalToConstant: Self.progressRingsSize[index].height),
                trialsProgressRing.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                trialsProgressRing.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            ])
            index += 1
        }

        if shaper.simulationContainContinousControls(),
           let progress = shaper.continuousControlGradeProgress()
        {
            continuousControlProgressRing.setProgress(progress, animated: true)
            view.addSubview(continuousControlProgressRing)

            NSLayoutConstraint.activate([
                continuousControlProgressRing.widthAnchor.constraint(equalToConstant: Self.progressRingsSize[index].width),
                continuousControlProgressRing.heightAnchor.constraint(equalToConstant: Self.progressRingsSize[index].height),
                continuousControlProgressRing.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                continuousControlProgressRing.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            ])
            index += 1
        }

        if shaper.simulationContainOptions(),
           let progress = shaper.optionsGradeProgress()
        {
            optionsProgressRing.setProgress(progress, animated: true)
            view.addSubview(optionsProgressRing)

            NSLayoutConstraint.activate([
                optionsProgressRing.widthAnchor.constraint(equalToConstant: Self.progressRingsSize[index].width),
                optionsProgressRing.heightAnchor.constraint(equalToConstant: Self.progressRingsSize[index].height),
                optionsProgressRing.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                optionsProgressRing.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            ])
        }

        return view
    }

    private func setupInformationsProgressViews() -> UIView {
        let stackView: UIStackView = .init().configure {
            $0.axis = .vertical
            $0.distribution = .fill
            $0.spacing = AppStyles.defaultSpacing
            $0.alignment = .leading
        }

        if shaper.simulationContainTrials() {
            let titleExamTypeLabel: UILabel = .init().configure {
                $0.text = PlomeCoreKit.L10n.trialsType
                $0.font = PlomeFont.bodyM.font
                $0.textColor = PlomeColor.darkBlue.color
            }

            let examGradeLabel: UILabel = .init().configure { [shaper] in
                $0.text = shaper.trialsGrade()
                $0.font = PlomeFont.demiBoldS.font
                $0.textColor = PlomeColor.trials.color
            }

            stackView.addArrangedSubview(UIStackView().configure(block: {
                $0.axis = .vertical
                $0.distribution = .fill
                $0.spacing = AppStyles.defaultSpacing(factor: 0.5)
                $0.alignment = .leading
                $0.addArrangedSubviews([titleExamTypeLabel, examGradeLabel])
            }))
        }

        if shaper.simulationContainContinousControls() {
            let titleExamTypeLabel: UILabel = .init().configure {
                $0.text = PlomeCoreKit.L10n.continuousControlsType
                $0.font = PlomeFont.bodyM.font
                $0.textColor = PlomeColor.darkBlue.color
            }

            let examGradeLabel: UILabel = .init().configure { [shaper] in
                $0.text = shaper.continousControlGrade()
                $0.font = PlomeFont.demiBoldS.font
                $0.textColor = PlomeColor.continuousControl.color
            }

            stackView.addArrangedSubview(UIStackView().configure(block: {
                $0.axis = .vertical
                $0.distribution = .fill
                $0.spacing = AppStyles.defaultSpacing(factor: 0.5)
                $0.alignment = .leading
                $0.addArrangedSubviews([titleExamTypeLabel, examGradeLabel])
            }))
        }

        if shaper.simulationContainOptions() {
            let titleExamTypeLabel: UILabel = .init().configure {
                $0.text = PlomeCoreKit.L10n.optionsType
                $0.font = PlomeFont.bodyM.font
                $0.textColor = PlomeColor.darkBlue.color
            }

            let examGradeLabel: UILabel = .init().configure { [shaper] in
                $0.text = shaper.optionGrade()
                $0.font = PlomeFont.demiBoldS.font
                $0.textColor = PlomeColor.options.color
            }

            stackView.addArrangedSubview(UIStackView().configure(block: {
                $0.axis = .vertical
                $0.distribution = .fill
                $0.spacing = AppStyles.defaultSpacing(factor: 0.5)
                $0.alignment = .leading
                $0.addArrangedSubviews([titleExamTypeLabel, examGradeLabel])
            }))
        }

        return stackView
    }
}
