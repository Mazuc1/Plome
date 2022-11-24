//
//  SimulationViewModelTests.swift
//  PlomeTests
//
//  Created by Loic Mazuc on 23/11/2022.
//

@testable import Plome
@testable import PlomeCoreKit
import PlomeCoreKitTestsHelpers
import XCTest

final class SimulationViewModelTests: XCTestCase {
    private var simulationsRouter: SimulationsRouter!

    override func setUp() {
        super.setUp()
        simulationsRouter = SimulationsRouter(screens: .init(context: testContext), rootTransition: EmptyTransition())
    }

    // MARK: - userDidTapDeleteExam

    func testWhenUserDeleteTrialExamThenExamIsDeleted() {
        // Arrange
        let simulation = Simulation(name: "", date: nil, exams: .init(), type: .generalBAC)
        simulation.add(exam: .init(name: "", coefficient: 1, grade: "13/20", type: .trial))
        let simulationViewModel = SimulationViewModel(router: simulationsRouter, simulation: simulation)

        // Act
        simulationViewModel.userDidTapDeleteExam(at: .init(row: 0, section: 0))

        // Assert
        XCTAssertTrue(simulationViewModel.simulation.exams(of: .trial).count == 0)
    }

    func testWhenUserDeleteContinousControlExamThenExamIsDeleted() {
        // Arrange
        let simulation = Simulation(name: "", date: nil, exams: .init(), type: .generalBAC)
        simulation.add(exam: .init(name: "", coefficient: 1, grade: "13/20", type: .continuousControl))
        let simulationViewModel = SimulationViewModel(router: simulationsRouter, simulation: simulation)

        // Act
        simulationViewModel.userDidTapDeleteExam(at: .init(row: 0, section: 1))

        // Assert
        XCTAssertTrue(simulationViewModel.simulation.exams(of: .continuousControl).count == 0)
    }

    func testWhenUserDeleteOptionExamThenExamIsDeleted() {
        // Arrange
        let simulation = Simulation(name: "", date: nil, exams: .init(), type: .generalBAC)
        simulation.add(exam: .init(name: "", coefficient: 1, grade: "13/20", type: .option))
        let simulationViewModel = SimulationViewModel(router: simulationsRouter, simulation: simulation)

        // Act
        simulationViewModel.userDidTapDeleteExam(at: .init(row: 0, section: 2))

        // Assert
        XCTAssertTrue(simulationViewModel.simulation.exams(of: .option).count == 0)
    }

    func testThatDeleteExamFailsWhenIndexPathSectionIsNotCorrect() {
        // Arrange
        let simulation = Simulation(name: "", date: nil, exams: .init(), type: .generalBAC)
        simulation.add(exam: .init(name: "", coefficient: 1, grade: "13/20", type: .option))
        simulation.add(exam: .init(name: "", coefficient: 1, grade: "13/20", type: .trial))
        simulation.add(exam: .init(name: "", coefficient: 1, grade: "13/20", type: .continuousControl))
        let simulationViewModel = SimulationViewModel(router: simulationsRouter, simulation: simulation)

        // Act
        simulationViewModel.userDidTapDeleteExam(at: .init(row: 0, section: 3))

        // Assert
        XCTAssertTrue(simulationViewModel.simulation.exams!.count == 3)
    }

    // MARK: - addExam

    func testWhenAddTrialExamThenExamIsAdded() {
        // Arrange
        let simulation = Simulation(name: "", date: nil, exams: .init(), type: .generalBAC)
        let simulationViewModel = SimulationViewModel(router: simulationsRouter, simulation: simulation)

        // Act
        simulationViewModel.addExam(name: "Test", in: .trial)

        // Assert
        XCTAssertTrue(simulationViewModel.simulation.exams(of: .trial).count == 1)
    }

    func testWhenAddContinuousControlExamThenExamIsAdded() {
        // Arrange
        let simulation = Simulation(name: "", date: nil, exams: .init(), type: .generalBAC)
        let simulationViewModel = SimulationViewModel(router: simulationsRouter, simulation: simulation)

        // Act
        simulationViewModel.addExam(name: "Test", in: .continuousControl)

        // Assert
        XCTAssertTrue(simulationViewModel.simulation.exams(of: .continuousControl).count == 1)
    }

    func testWhenAddOptionExamThenExamIsAdded() {
        // Arrange
        let simulation = Simulation(name: "", date: nil, exams: .init(), type: .generalBAC)
        let simulationViewModel = SimulationViewModel(router: simulationsRouter, simulation: simulation)

        // Act
        simulationViewModel.addExam(name: "Test", in: .option)

        // Assert
        XCTAssertTrue(simulationViewModel.simulation.exams(of: .option).count == 1)
    }

    // MARK: - userDidChangeValue

    func testWhenMissingOneOrMoreExamGradeThenCalculationIsDisabled() {
        // Arrange
        let simulation = Simulation(name: "", date: nil, exams: .init(), type: .generalBAC)
        simulation.add(exam: .init(name: "", coefficient: 1, grade: "13/20", type: .option))
        simulation.add(exam: .init(name: "", coefficient: 1, grade: nil, type: .trial))
        simulation.add(exam: .init(name: "", coefficient: 1, grade: "13/20", type: .continuousControl))
        let simulationViewModel = SimulationViewModel(router: simulationsRouter, simulation: simulation)

        // Act
        simulationViewModel.userDidChangeValue()

        // Assert
        XCTAssertFalse(simulationViewModel.canCalculate)
    }

    func testWhenAllExamGradeAreFilledThenCalculationIsEnabled() {
        // Arrange
        let simulation = Simulation(name: "", date: nil, exams: .init(), type: .generalBAC)
        simulation.add(exam: .init(name: "", coefficient: 1, grade: "13/20", type: .option))
        simulation.add(exam: .init(name: "", coefficient: 1, grade: "12/20", type: .trial))
        simulation.add(exam: .init(name: "", coefficient: 1, grade: "13/20", type: .continuousControl))
        let simulationViewModel = SimulationViewModel(router: simulationsRouter, simulation: simulation)

        // Act
        simulationViewModel.userDidChangeValue()

        // Assert
        XCTAssertTrue(simulationViewModel.canCalculate)
    }
}
