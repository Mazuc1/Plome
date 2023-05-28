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
        average == -1 ? L10n.Home.placeholerGrade : L10n.Home.average(average)
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
            case .filled: return L10n.Home.allGradeFill
            case .missing: return L10n.Home.notAllGradeFill
            }
        }

        var icon: UIImage {
            switch self {
            case .filled: return Icons.success.configure(weight: .regular, color: .lagoon, size: 15)
            case .missing: return Icons.warning.configure(weight: .regular, color: .warning, size: 15)
            }
        }
    }
}
