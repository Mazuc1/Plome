//
//  SimulationViewModelTests.swift
//  PlomeTests
//
//  Created by Loic Mazuc on 23/11/2022.
//

import Dependencies
@testable import Plome
@testable import PlomeCoreKit
import PlomeCoreKitTestsHelpers
import XCTest

final class SimulationViewModelTests: XCTestCase {
    private var simulationsRouter: SimulationsRouter!

    override func setUp() {
        super.setUp()
        simulationsRouter = SimulationsRouter(screens: .init(), rootTransition: EmptyTransition())
    }

    // MARK: - didChangeSimulationExamGrade

    func testWhenMissingOneOrMoreExamGradeThenCalculationIsDisabled() {
        // Arrange
        let simulation = Simulation(name: "", date: nil, exams: .init(), type: .generalBAC)
        simulation.add(exam: .init(name: "", coefficient: 1, grade: 13, ratio: 20, type: .option))
        simulation.add(exam: .init(name: "", coefficient: 1, grade: nil, ratio: 20, type: .trial))
        simulation.add(exam: .init(name: "", coefficient: 1, grade: 13, ratio: 20, type: .continuousControl))
        let simulationViewModel = SimulationViewModel(router: simulationsRouter, simulation: simulation)

        // Act
        simulationViewModel.didChangeSimulationExamGrade()

        // Assert
        XCTAssertFalse(simulationViewModel.canCalculate)
    }

    func testWhenAllExamGradeAreFilledThenCalculationIsEnabled() {
        // Arrange
        let simulation = Simulation(name: "", date: nil, exams: .init(), type: .generalBAC)
        simulation.add(exam: .init(name: "", coefficient: 1, grade: 13, ratio: 20, type: .option))
        simulation.add(exam: .init(name: "", coefficient: 1, grade: 12, ratio: 20, type: .trial))
        simulation.add(exam: .init(name: "", coefficient: 1, grade: 13, ratio: 20, type: .continuousControl))
        let simulationViewModel = SimulationViewModel(router: simulationsRouter, simulation: simulation)

        // Act
        simulationViewModel.didChangeSimulationExamGrade()

        // Assert
        XCTAssertTrue(simulationViewModel.canCalculate)
    }
}
