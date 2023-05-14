//
//  SimulationLiveInfos.swift
//  Plome
//
//  Created by Loic Mazuc on 14/05/2023.
//

import Foundation
import PlomeCoreKit
import UIKit

struct SimulationLiveInfos {
    private let average: Float
    private let isAllGradeSet: Bool
    let mention: Mention
    
    var gradesState: GradesState {
        isAllGradeSet ? .filled : .missing
    }
    
    var averageText: String {
        average == -1 ? "-- / 20" : "\(average.truncate(places: 2)) / 20"
    }
    
    init(average: Float, isAllGradeSet: Bool, mention: Mention) {
        self.average = average
        self.isAllGradeSet = isAllGradeSet
        self.mention = mention
    }
    
    enum GradesState {
        case filled, missing
        
        var description: String {
            switch self {
            case .filled: return "Toutes les note sont remplis !"
            case .missing: return "Toutes les note ne sont pas remplis."
            }
        }
        
        var icon: UIImage {
            switch self {
            case .filled: return Icons.success.configure(weight: .regular, color: .success, size: 15)
            case .missing: return Icons.fail.configure(weight: .regular, color: .fail, size: 15)
            }
        }
    }
}
