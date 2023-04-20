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
    private var viewControllers = [UIViewController(), UIViewController(), UIViewController()]
    
    
    private let bar: TMBar = TMBar.ButtonBar().configure { bar in
        bar.layout.transitionStyle = .progressive
        bar.backgroundView.style = .clear
        bar.indicator.tintColor = .black
        bar.indicator.weight = .light
        
        bar.buttons.customize {
            $0.font = PlomeFont.demiBoldM.font
            $0.selectedTintColor = .black
            $0.tintColor = .gray
            $0.backgroundColor = PlomeColor.background.color
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        TMBarItem(title: "Page \(index)")
    }
}
