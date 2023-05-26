//
//  ExamTypePageViewController.swift
//  Plome
//
//  Created by Loic Mazuc on 20/04/2023.
//

import Pageboy
import PlomeCoreKit
import Tabman
import UIKit

protocol ExamTypePageViewControllerInput: AnyObject {
    func updateTableViews()
}

final class ExamTypePageViewController: TabmanViewController {
    // MARK: - Properties

    private var viewControllers: [ExamListViewController] = []
    private let viewModel: ExamTypePageViewModel

    // MARK: - UI

    private let bar: TMBar = .ButtonBar().configure { bar in
        bar.layout.transitionStyle = .progressive
        bar.backgroundView.style = .flat(color: PlomeColor.background.color)
        bar.indicator.tintColor = .black
        bar.indicator.weight = .light

        bar.buttons.customize {
            $0.font = PlomeFont.demiBoldM.font
            $0.selectedTintColor = .black
            $0.tintColor = .gray
            $0.backgroundColor = PlomeColor.background.color
        }
    }

    // MARK: - Init

    required init(viewModel: ExamTypePageViewModel) {
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

        viewModel.examTypes.forEach {
            viewControllers.append(.init(exams: viewModel.getExam(of: $0)))
        }

        viewControllers.forEach { $0.simulationViewModelInput = viewModel.simulationViewModelInput }

        dataSource = self
        addBar(bar, dataSource: self, at: .top)
    }

    // MARK: - Methods
}

extension ExamTypePageViewController: ExamTypePageViewControllerInput {
    func updateTableViews() {
        viewControllers.forEach { $0.tableView.reloadData() }
    }
}

extension ExamTypePageViewController: PageboyViewControllerDataSource, TMBarDataSource {
    func numberOfViewControllers(in _: Pageboy.PageboyViewController) -> Int {
        viewControllers.count
    }

    func viewController(for _: Pageboy.PageboyViewController, at index: Pageboy.PageboyViewController.PageIndex) -> UIViewController? {
        viewControllers[index]
    }

    func defaultPage(for _: Pageboy.PageboyViewController) -> Pageboy.PageboyViewController.Page? { nil }

    func barItem(for _: Tabman.TMBar, at index: Int) -> Tabman.TMBarItemable {
        TMBarItem(title: viewModel.examTypes[index].title)
    }
}

// MARK: - ExamListViewController

final class ExamListViewController: UITableViewController {
    // MARK: - Properties

    let exams: [Exam]
    weak var simulationViewModelInput: SimulationViewModelInput?

    // MARK: - Init

    required init(exams: [Exam]) {
        self.exams = exams
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = PlomeColor.background.color
        tableView.register(ExamCell.self, forCellReuseIdentifier: ExamCell.reuseIdentifier)
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int { exams.count }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ExamCell.reuseIdentifier, for: indexPath) as? ExamCell else { return UITableViewCell() }
        cell.setup(exam: exams[indexPath.row])
        cell.simulationViewModelInput = simulationViewModelInput
        return cell
    }
}
