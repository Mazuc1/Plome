//
//  SimulationDetailsViewController.swift
//  Plome
//
//  Created by Loic Mazuc on 24/11/2022.
//

import PlomeCoreKit
import UIKit

class SimulationDetailsViewController: AppViewController {
    // MARK: - Properties

    let viewModel: SimulationDetailsViewModel

    private var widthWithoutMargin: CGFloat = 100

    // MARK: - UI

    private let detailsSectionLabel: UILabel = .init().configure {
        $0.text = L10n.Home.yourGrades
        $0.font = PlomeFont.demiBoldM.font
        $0.textColor = PlomeColor.darkBlue.color
        $0.textAlignment = .left
    }

    private let gradeInformationsStackView: UIStackView = .init().configure {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = AppStyles.defaultSpacing
        $0.alignment = .leading
    }

    private let examGradeTypeStackView: UIStackView = .init().configure {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = AppStyles.defaultSpacing
        $0.alignment = .center
    }

    private lazy var tertiaryCTARemakeSimulation: TertiaryCTA = .init(title: L10n.Home.remakeSimulationFromThisOne).configure { [weak self] in
        $0.addTarget(self, action: #selector(userDidTapRemakeSimulation), for: .touchUpInside)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private let scrollViewContainerStackView: UIStackView = .init().configure {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = AppStyles.defaultSpacing(factor: 2)
        $0.alignment = .leading
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = .init(top: AppStyles.defaultSpacing(factor: 2),
                                 left: AppStyles.defaultSpacing(factor: 2),
                                 bottom: AppStyles.defaultSpacing(factor: 2),
                                 right: AppStyles.defaultSpacing(factor: 2))
    }

    private let scrollView: UIScrollView = .init().configure {
        $0.showsVerticalScrollIndicator = false
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: - Init

    required init(viewModel: SimulationDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        hidesBottomBarWhenPushed = true
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = viewModel.simulation.name
        navigationItem.rightBarButtonItem = createDeleteBarButton()

        widthWithoutMargin = view.frame.width - AppStyles.defaultSpacing(factor: 4)
        setupLayout()
    }

    // MARK: - Methods

    private func setupLayout() {
        let detailsHeaderView = DetailsHeaderView(frame: .zero, shaper: viewModel.shaper)
        scrollViewContainerStackView.addArrangedSubviews([detailsHeaderView, detailsSectionLabel])

        let gradeInformationView = GradeInformationCell(frame: .zero, title: L10n.Home.finalGrade, grade: viewModel.shaper.finalGradeOutOfTwenty())
        gradeInformationsStackView.addArrangedSubview(gradeInformationView)

        let examsTypeGradeView = ExamsTypeGradeView(frame: .zero, shaper: viewModel.shaper)
        gradeInformationsStackView.addArrangedSubview(examsTypeGradeView)

        let worstExamView = ExamInformationsView(frame: .zero, shaper: viewModel.shaper, gradeType: .worst)
        let betterExamView = ExamInformationsView(frame: .zero, shaper: viewModel.shaper, gradeType: .better)
        examGradeTypeStackView.addArrangedSubviews([betterExamView, worstExamView])
        gradeInformationsStackView.addArrangedSubview(examGradeTypeStackView)

        scrollViewContainerStackView.addArrangedSubview(gradeInformationsStackView)

        if viewModel.shaper.displayCatchUpSectionIfNeeded() {
            guard let catchUpView = createCatchUpView() else { return }
            scrollViewContainerStackView.addArrangedSubview(catchUpView)

            NSLayoutConstraint.activate([
                catchUpView.widthAnchor.constraint(equalToConstant: widthWithoutMargin),
            ])
        }

        scrollViewContainerStackView.addArrangedSubview(tertiaryCTARemakeSimulation)

        scrollViewContainerStackView.stretchInView(parentView: scrollView)

        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollViewContainerStackView.widthAnchor.constraint(equalToConstant: view.frame.width),

            detailsHeaderView.widthAnchor.constraint(equalToConstant: widthWithoutMargin),
            gradeInformationView.widthAnchor.constraint(equalToConstant: widthWithoutMargin),
            examsTypeGradeView.widthAnchor.constraint(equalToConstant: widthWithoutMargin),
            examGradeTypeStackView.widthAnchor.constraint(equalToConstant: widthWithoutMargin),
            tertiaryCTARemakeSimulation.heightAnchor.constraint(equalToConstant: AppStyles.secondaryCTAHeight),
            tertiaryCTARemakeSimulation.widthAnchor.constraint(equalToConstant: widthWithoutMargin),
        ])
    }

    private func createCatchUpView() -> UIView? {
        guard let catchUpInformations = viewModel.shaper.getCatchUpInformations() else { return nil }
        return CatchUpView(frame: .zero, grade: catchUpInformations.grade, differenceAfterCatchUp: catchUpInformations.difference)
    }

    private func createDeleteBarButton() -> UIBarButtonItem {
        UIBarButtonItem(image: Icons.trash.configure(weight: .regular, color: .pink, size: 20), style: .plain, target: self, action: #selector(userDidTapDeleteSimulation))
    }

    @objc private func userDidTapDeleteSimulation() {
        viewModel.userDidTapDeleteSimulation()
    }

    @objc private func userDidTapRemakeSimulation() {
        viewModel.userDidTapRemakeSimulation()
    }
}
