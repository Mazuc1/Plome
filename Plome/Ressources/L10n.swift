// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum L10n {
  /// Comment se nomme votre %@
  public static func howNamedYour(_ p1: Any) -> String {
    return L10n.tr("Plome", "how_named_your", String(describing: p1), fallback: "Comment se nomme votre %@")
  }
  /// Accueil
  public static let tabBarHome = L10n.tr("Plome", "tabBar_home", fallback: "Accueil")
  /// Modèles
  public static let tabBarModel = L10n.tr("Plome", "tabBar_model", fallback: "Modèles")
  /// Réglages
  public static let tabBarSettings = L10n.tr("Plome", "tabBar_settings", fallback: "Réglages")
  public enum Home {
    /// Admis
    public static let admit = L10n.tr("Plome", "home.admit", fallback: "Admis")
    /// Meilleur note
    public static let bestGrade = L10n.tr("Plome", "home.best_grade", fallback: "Meilleur note")
    /// Calculer
    public static let calculate = L10n.tr("Plome", "home.calculate", fallback: "Calculer")
    /// Coeff.
    public static let coeff = L10n.tr("Plome", "home.coeff", fallback: "Coeff.")
    /// 1.0
    public static let coeffPlaceholder = L10n.tr("Plome", "home.coeff_placeholder", fallback: "1.0")
    /// Vous avez modifié le modèle utilisé ? Pensez à l'enregistrer.
    public static let editModelThinkToSave = L10n.tr("Plome", "home.edit_model_think_to_save", fallback: "Vous avez modifié le modèle utilisé ? Pensez à l'enregistrer.")
    /// Vous retrouverez ici toutes vos simulations d’examens.
    /// 
    /// Vous pouvez reprendre une existante pour la modifier.
    public static let emptySimulationPlaceholder = L10n.tr("Plome", "home.empty_simulation_placeholder", fallback: "Vous retrouverez ici toutes vos simulations d’examens.\n\nVous pouvez reprendre une existante pour la modifier.")
    /// Note final
    public static let finalGrade = L10n.tr("Plome", "home.final_grade", fallback: "Note final")
    /// Note
    public static let grade = L10n.tr("Plome", "home.grade", fallback: "Note")
    /// 08/20
    public static let gradePlaceholder = L10n.tr("Plome", "home.grade_placeholder", fallback: "08/20")
    /// Comment vous rattrapez ?
    public static let howToCatchUp = L10n.tr("Plome", "home.how_to_catchUp", fallback: "Comment vous rattrapez ?")
    /// Comment complétez la simulation ?
    public static let howToCompleteSimulation = L10n.tr("Plome", "home.how_to_complete_simulation", fallback: "Comment complétez la simulation ?")
    /// C'est fait !
    public static let itsDone = L10n.tr("Plome", "home.its_done", fallback: "C'est fait !")
    /// Le modèle à bien été enregistrer
    public static let modelHasBeenSave = L10n.tr("Plome", "home.model_has_been_save", fallback: "Le modèle à bien été enregistrer")
    /// Ma simulation
    public static let mySimulation = L10n.tr("Plome", "home.my_simulation", fallback: "Ma simulation")
    /// Mes simulations
    public static let mySimulations = L10n.tr("Plome", "home.my_simulations", fallback: "Mes simulations")
    /// Nouvelle simulation
    public static let newSimulation = L10n.tr("Plome", "home.new_simulation", fallback: "Nouvelle simulation")
    /// Refaire une simulation
    public static let remakeSimulation = L10n.tr("Plome", "home.remake_simulation", fallback: "Refaire une simulation")
    /// Re simuler à partir de cette simulation
    public static let remakeSimulationFromThisOne = L10n.tr("Plome", "home.remake_simulation_from_this_one", fallback: "Re simuler à partir de cette simulation")
    /// Résultat
    public static let result = L10n.tr("Plome", "home.result", fallback: "Résultat")
    /// Retourner à l'accueil
    public static let returnToHome = L10n.tr("Plome", "home.return_to_home", fallback: "Retourner à l'accueil")
    /// Enregistrer ce modèle
    public static let saveModel = L10n.tr("Plome", "home.save_model", fallback: "Enregistrer ce modèle")
    /// Sélectionnez un modèle
    public static let selectAModel = L10n.tr("Plome", "home.select_a_model", fallback: "Sélectionnez un modèle")
    /// Simulation du %@
    public static func simulationFromDate(_ p1: Any) -> String {
      return L10n.tr("Plome", "home.simulation_from_date", String(describing: p1), fallback: "Simulation du %@")
    }
    /// Voici les quelques règles pour bien faire votre simulation.
    /// 
    /// 1. Les nombres à décimaux s'écrivent avec des points.
    /// 
    /// 2. Les notes doivent être séparer avec un /.
    /// 
    /// 3. Si vous n'indiquez pas de coefficient, il sera automatiquement mis à 1 lors du calcul.
    public static let simulationRules = L10n.tr("Plome", "home.simulation_rules", fallback: "Voici les quelques règles pour bien faire votre simulation.\n\n1. Les nombres à décimaux s'écrivent avec des points.\n\n2. Les notes doivent être séparer avec un /.\n\n3. Si vous n'indiquez pas de coefficient, il sera automatiquement mis à 1 lors du calcul.")
    /// Quelques chiffres
    public static let someNumbers = L10n.tr("Plome", "home.some_numbers", fallback: "Quelques chiffres")
    /// Non admis
    public static let unadmit = L10n.tr("Plome", "home.unadmit", fallback: "Non admis")
    /// Pire note
    public static let worstGrade = L10n.tr("Plome", "home.worst_grade", fallback: "Pire note")
    /// Vous obtiendrez votre diplôme en obtenant des points supplémentaires:
    public static let youWillObtainYourDiploma = L10n.tr("Plome", "home.you_will_obtain_your_diploma", fallback: "Vous obtiendrez votre diplôme en obtenant des points supplémentaires:")
    /// Votre note sera alors de
    public static let yourGradeWillBe = L10n.tr("Plome", "home.your_grade_will_be", fallback: "Votre note sera alors de")
    /// Vos notes
    public static let yourGrades = L10n.tr("Plome", "home.your_grades", fallback: "Vos notes")
  }
  public enum Settings {
    /// Ajouter les modèles par défaut
    public static let addDefaultModel = L10n.tr("Plome", "settings.add_default_model", fallback: "Ajouter les modèles par défaut")
    /// Toutes les simulations ont bien été supprimées.
    public static let allSimulationHasBeenDeleted = L10n.tr("Plome", "settings.all_simulation_has_been_deleted", fallback: "Toutes les simulations ont bien été supprimées.")
    /// L'application à bien été réinitialisé.
    public static let appHasBeenReinitialized = L10n.tr("Plome", "settings.app_has_been_reinitialized", fallback: "L'application à bien été réinitialisé.")
    /// Plôme
    public static let appName = L10n.tr("Plome", "settings.app_name", fallback: "Plôme")
    /// mazuc.loic@icloud.com
    public static let assistanceMail = L10n.tr("Plome", "settings.assistance_mail", fallback: "mazuc.loic@icloud.com")
    /// Contacter l'assistance
    public static let contactAssistance = L10n.tr("Plome", "settings.contact_assistance", fallback: "Contacter l'assistance")
    /// Les modèle de simulation ont bien été ajoutées.
    public static let defaultModelHasBeenAdded = L10n.tr("Plome", "settings.default_model_has_been_added", fallback: "Les modèle de simulation ont bien été ajoutées.")
    /// Vous ne semblez pas avoir d'application d'email.
    /// Vous pouvez nous joindre à l'adresse suivante: mazuc.loic@icloud.com
    public static let errorLaunchMailApp = L10n.tr("Plome", "settings.error_launch_mail_app", fallback: "Vous ne semblez pas avoir d'application d'email.\nVous pouvez nous joindre à l'adresse suivante: mazuc.loic@icloud.com")
    /// 9.99
    public static let errorAppVersion = L10n.tr("Plome", "settings.errorAppVersion", fallback: "9.99")
    /// Général
    public static let general = L10n.tr("Plome", "settings.general", fallback: "Général")
    /// Autres
    public static let other = L10n.tr("Plome", "settings.other", fallback: "Autres")
    /// Réinitialiser l'application
    public static let reintializeApp = L10n.tr("Plome", "settings.reintialize_app", fallback: "Réinitialiser l'application")
    /// Supprimer les simulations
    public static let removeAllSimulations = L10n.tr("Plome", "settings.remove_all_simulations", fallback: "Supprimer les simulations")
    /// Réglages
    public static let settings = L10n.tr("Plome", "settings.settings", fallback: "Réglages")
    /// Version %@
    public static func version(_ p1: Any) -> String {
      return L10n.tr("Plome", "settings.version", String(describing: p1), fallback: "Version %@")
    }
    /// Vous vous apprêtez à supprimer toutes les données de l'application, êtes-vous sur de vouloir continuer ?
    public static let warningMessageReinitialize = L10n.tr("Plome", "settings.warning_message_reinitialize", fallback: "Vous vous apprêtez à supprimer toutes les données de l'application, êtes-vous sur de vouloir continuer ?")
    /// Vous vous apprêtez à supprimer toutes les simulations, êtes-vous sur de vouloir continuer ?
    public static let warningMessageRemoveSimulations = L10n.tr("Plome", "settings.warning_message_remove_simulations", fallback: "Vous vous apprêtez à supprimer toutes les simulations, êtes-vous sur de vouloir continuer ?")
  }
  public enum SimulationModels {
    /// Vous retrouverez ici tous vos modèles de simulations d’examens.
    /// 
    /// Vous pouvez reprendre une existante pour la modifier.
    /// 
    /// Vous trouverez également des modèles par défaut dans les réglages de l'application.
    public static let emptyModelPlaceholder = L10n.tr("Plome", "simulationModels.empty_model_placeholder", fallback: "Vous retrouverez ici tous vos modèles de simulations d’examens.\n\nVous pouvez reprendre une existante pour la modifier.\n\nVous trouverez également des modèles par défaut dans les réglages de l'application.")
    /// Nouveau modèle
    public static let newModel = L10n.tr("Plome", "simulationModels.new_model", fallback: "Nouveau modèle")
    /// %d Contrôles continue
    public static func numberOfContinousControls(_ p1: Int) -> String {
      return L10n.tr("Plome", "simulationModels.number_of_continous_controls", p1, fallback: "%d Contrôles continue")
    }
    /// %d Options
    public static func numberOfOptions(_ p1: Int) -> String {
      return L10n.tr("Plome", "simulationModels.number_of_options", p1, fallback: "%d Options")
    }
    /// %d Epreuves
    public static func numberOfTrials(_ p1: Int) -> String {
      return L10n.tr("Plome", "simulationModels.number_of_trials", p1, fallback: "%d Epreuves")
    }
    /// Bac Pro...
    public static let simulationModelPlaceholderName = L10n.tr("Plome", "simulationModels.simulation_model_placeholder_name", fallback: "Bac Pro...")
    /// Vous vous apprêtez à supprimer ce modèle. Êtes vous sur de vouloir le supprimer ?
    public static let warningMessageRemoveModel = L10n.tr("Plome", "simulationModels.warning_message_remove_model", fallback: "Vous vous apprêtez à supprimer ce modèle. Êtes vous sur de vouloir le supprimer ?")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
