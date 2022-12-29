//
//  AppContextualAction.swift
//  PlomeCoreKit
//
//  Created by Loic Mazuc on 28/10/2022.
//

import Foundation
import UIKit

public enum AppContextualAction {
    public static func deleteAction(action: @escaping () -> Void) -> UIContextualAction {
        UIContextualAction(style: .destructive, title: nil) { _, _, completion in
            action()
            completion(true)
        }.configure {
            $0.backgroundColor = PlomeColor.background.color
            $0.image = Icons.trash.configure(weight: .regular, color: .fail, size: 20)
        }
    }
    
    public static func shareAction(action: @escaping () -> Void) -> UIContextualAction {
        UIContextualAction(style: .normal, title: nil) { _, _, completion in
            action()
            completion(true)
        }.configure {
            $0.backgroundColor = PlomeColor.background.color
            $0.image = Icons.upload.configure(weight: .regular, color: .lagoon, size: 20)
        }
    }
}
