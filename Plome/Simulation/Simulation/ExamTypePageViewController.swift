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
    
    private lazy var layout: UICollectionViewFlowLayout = .init().configure {
        $0.itemSize = CGSize(width: (view.frame.width / 3) - AppStyles.defaultSpacing(factor: 2),
                             height: (view.frame.width / 3) - AppStyles.defaultSpacing(factor: 2))
        $0.minimumLineSpacing = AppStyles.defaultSpacing
        $0.minimumInteritemSpacing = 1
        $0.scrollDirection = .vertical
        $0.sectionInset = .init(top: AppStyles.defaultSpacing,
                                left: AppStyles.defaultSpacing(factor: 0.5),
                                bottom: AppStyles.defaultSpacing,
                                right: AppStyles.defaultSpacing(factor: 0.5))
    }
    
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
            viewControllers.append(.init(collectionViewLayout: layout))
        }
        
        self.dataSource = self        
        addBar(bar, dataSource: self, at: .top)
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

final class GridExamTypeViewController: UICollectionViewController {
    
    // MARK: - Properties
    
    private let reuseIdentifier: String = "cell"
    
    // MARK: - UI
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = PlomeColor.background.color
        collectionView.register(UICollectionViewCell.self,
                                forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Should return number of exam for section type
        return 12
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath).configure {
            $0.backgroundColor = .blue
        }
    }
}
