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
    
    private var viewControllers: [GridExamTypeViewController] = []
    private let titles: [String]
    
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
    
//    private lazy var layout: UICollectionViewFlowLayout = .init().configure {
//        $0.itemSize = CGSize(width: calculateCellWidth(),
//                             height: 110)
//        $0.minimumLineSpacing = AppStyles.defaultSpacing
//        $0.minimumInteritemSpacing = AppStyles.defaultSpacing
//        $0.scrollDirection = .vertical
//        $0.sectionInset = .init(top: AppStyles.defaultSpacing,
//                                left: AppStyles.defaultSpacing(factor: 0.5),
//                                bottom: AppStyles.defaultSpacing,
//                                right: AppStyles.defaultSpacing(factor: 0.5))
//    }
    
    // MARK: - Init
    
    required init(titles: [String]) {
        self.titles = titles
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for _ in 0..<titles.count {
            viewControllers.append(.init())
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
        TMBarItem(title: titles[index])
    }
}

final class GridExamTypeViewController: UITableViewController {
    
    // MARK: - Properties
        
    // MARK: - UI
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = PlomeColor.background.color
        tableView.register(ExamCell.self, forCellReuseIdentifier: ExamCell.reuseIdentifier)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (3...7).randomElement()!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ExamCell.reuseIdentifier, for: indexPath) as? ExamCell else { return UITableViewCell() }
        cell.setup(exam: .init(name: "Test", coefficient: 1, grade: 12, ratio: 20, type: .trial))
        return cell
    }
}
