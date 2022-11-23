//
//  SimulationResultViewModelTests.swift
//  PlomeTests
//
//  Created by Loic Mazuc on 23/11/2022.
//

@testable import Plome
import XCTest
@testable import PlomeCoreKit
import Combine

final class SimulationResultViewModelTests: XCTestCase {
    private var simulationsRouter: SimulationsRouter!
    private var simulationResultViewModel: SimulationResultViewModel!
    private var simulationRepository: CoreDataRepository<CDSimulation>!
    private var mockCoreData: MockCoreData!
    private var cancellables: Set<AnyCancellable> = []
    
    private var simulation: Simulation!

    override func setUp() {
        super.setUp()

        mockCoreData = MockCoreData()
        simulationRepository = CoreDataRepository(storageProvider: mockCoreData)
        
        simulation = .init(name: "Test", date: nil, exams: nil, type: .generalBAC)
        
        simulationsRouter = SimulationsRouter(screens: .init(context: testContext), rootTransition: EmptyTransition())
        simulationResultViewModel = SimulationResultViewModel(router: simulationsRouter, simulation: simulation, simulationRepository: simulationRepository)
    }
    
    // simulationContainTrials -> true / false
    // simulationContainContinousControls -> true / false
    // simulationContainOptions -> true / false
    
    // hasSucceedExam -> true / false
    // displayCatchUpSectionIfNeeded -> true / false
    
    // getCatchUpInformations -> not nil quand catchUp
    
    // admissionSentence -> bon resultat en fonction de succeed
    // resultSentence -> bon resultat en fonction de succeed
    
    func testWhenSimulationContainsTrialsThenReturnedTrue() {
        // Arrange
        let simulation = Simulation(name: <#T##String#>, date: <#T##Date?#>, exams: <#T##Set<Exam>?#>, type: <#T##SimulationType#>)
        simulationResultViewModel = SimulationResultViewModel(router: simulationsRouter, simulation: simulation, simulationRepository: simulationRepository)

        // Act

        // Assert
    }
}

// Arrange

// Act

// Assert
