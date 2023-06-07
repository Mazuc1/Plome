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
        average == -1 ? L10n.Home.placeholerGrade : "\(average.truncate(places: 2)) / 20"
    }

    init(average: Float, isAllGradeSet: Bool, mention: Mention) {
        self.average = average
        self.isAllGradeSet = isAllGradeSet
        self.mention = mention
    }

    func averageTextColor() -> UIColor {
        guard gradesState == .filled else { return PlomeColor.darkGray.color }
        return average.truncate(places: 2) >= 10 ? PlomeColor.success.color : PlomeColor.fail.color
    }

    enum GradesState {
        case filled, missing

        var description: String {
            switch self {
            case .filled: return L10n.Home.allGradeFill
            case .missing: return L10n.Home.notAllGradeFill
            }
        }
    }
}
