//
//  ExamTypePageViewController.swift
//  Plome
//
//  Created by Loic Mazuc on 20/04/2023.
//

import UIKit
import PlomeCoreKit
import Tabman
import Pageboy

final class ExamTypePageViewController: TabmanViewController {
    
    // MARK: - Properties
    
    private var viewControllers: [ExamListViewController] = []
    private let viewModel: ExamTypePageViewModel
    
    // MARK: - UI
    
    private let bar: TMBar = TMBar.ButtonBar().configure { bar in
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.examTypes.forEach {
            viewControllers.append(.init(numberOfRows: viewModel.numberOfRows(for: $0)))
        }
        
        self.dataSource = self        
        addBar(bar, dataSource: self, at: .top)
    }
    
    // MARK: - Methods
    
    private func calculateCellWidth() -> CGFloat {
        let spacing: CGFloat = AppStyles.defaultSpacing(factor: 4)
        let insets: CGFloat = 8
        let minimumLineSpacing: CGFloat = AppStyles.defaultSpacing
        
        var calculatedWidth = view.frame.width - spacing
        calculatedWidth -= insets
        calculatedWidth -= minimumLineSpacing
        
        return CGFloat(calculatedWidth / 2)
    }
}

extension ExamTypePageViewController: PageboyViewControllerDataSource, TMBarDataSource {
    func numberOfViewControllers(in pageboyViewController: Pageboy.PageboyViewController) -> Int {
        viewControllers.count
    }
    
    func viewController(for pageboyViewController: Pageboy.PageboyViewController, at index: Pageboy.PageboyViewController.PageIndex) -> UIViewController? {
        viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: Pageboy.PageboyViewController) -> Pageboy.PageboyViewController.Page? {
        nil
    }
    
    func barItem(for bar: Tabman.TMBar, at index: Int) -> Tabman.TMBarItemable {
        TMBarItem(title: viewModel.examTypes[index].title)
    }
}

final class ExamListViewController: UITableViewController {
    
    // MARK: - Properties
    
    let numberOfRows: Int
        
    // MARK: - Init
    
    required init(numberOfRows: Int) {
        self.numberOfRows = numberOfRows
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ExamCell.reuseIdentifier, for: indexPath) as? ExamCell else { return UITableViewCell() }
        cell.setup(exam: .init(name: "Test", coefficient: 1, grade: 12, ratio: 20, type: .trial))
        return cell
    }
}
