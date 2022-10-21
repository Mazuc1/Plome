//
//  DefaultSimulationModelsProvider.swift
//  PlomeCoreKit
//
//  Created by Loic Mazuc on 14/10/2022.
//

import Foundation
import CoreData

final public class DefaultSimulationModelsProvider {
    
    // MARK: - Properties
    
    private let storageProvider: StorageProvider
    
    // MARK: - Init
    
    public init(storageProvider: StorageProvider) {
        self.storageProvider = storageProvider
    }
    
    private func buildBrevetSimluationModel() {
        let simulationModel = CDSimulation(context: storageProvider.context)
        simulationModel.exams = toCoreData(exams: BrevetExamsProvider.allExams())
    }
    
    private func toCoreData(exams: [Exam]) -> Set<CDExam> {
        var cdExams = Set<CDExam>.init()
        
        _ = exams.map {
            let cdExam = CDExam(context: storageProvider.context)
            cdExam.name = $0.name
            cdExam.type = $0.type
            cdExams.insert(cdExam)
        }
        
        return cdExams
    }
}
