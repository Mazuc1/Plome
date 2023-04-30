//
//  ExamTypePageViewModel.swift
//  Plome
//
//  Created by Loic Mazuc on 30/04/2023.
//

import Foundation
import PlomeCoreKit

final class ExamTypePageViewModel {
    // MARK: - Properties
    
    private let simulation: Simulation
    
    lazy var examTypes: [ExamType] = {
        simulation.examTypes()
    }()
    
    // MARK: - Init
    
    init(simulation: Simulation) {
        self.simulation = simulation
    }
    
    // MARK: - Methods
    
    func numberOfRows(for type: ExamType) -> Int {
        simulation.number(of: type)
    }
    
    func getExam(for index: Int) -> [Exam] {
        switch index {
        case 0: return simulation.exams(of: .trial)
        case 1: return simulation.exams(of: .continuousControl)
        case 2: return simulation.exams(of: .option)
        default: return []
        }
    }
}
