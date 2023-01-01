// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum L10n {
  /// What is the name of your %@
  public static func howNamedYour(_ p1: Any) -> String {
    return L10n.tr("Plome", "how_named_your", String(describing: p1), fallback: "What is the name of your %@")
  }
  /// Home
  public static let tabBarHome = L10n.tr("Plome", "tabBar_home", fallback: "Home")
  /// Model
  public static let tabBarModel = L10n.tr("Plome", "tabBar_model", fallback: "Model")
  /// Settings
  public static let tabBarSettings = L10n.tr("Plome", "tabBar_settings", fallback: "Settings")
  public enum Home {
    /// Admit
    public static let admit = L10n.tr("Plome", "home.admit", fallback: "Admit")
    /// Best grade
    public static let bestGrade = L10n.tr("Plome", "home.best_grade", fallback: "Best grade")
    /// Calculate
    public static let calculate = L10n.tr("Plome", "home.calculate", fallback: "Calculate")
    /// Coeff.
    public static let coeff = L10n.tr("Plome", "home.coeff", fallback: "Coeff.")
    /// 1.0
    public static let coeffPlaceholder = L10n.tr("Plome", "home.coeff_placeholder", fallback: "1.0")
    /// Have you changed the template used? Consider saving it.
    public static let editModelThinkToSave = L10n.tr("Plome", "home.edit_model_think_to_save", fallback: "Have you changed the template used? Consider saving it.")
    /// You will find here all your exam simulations.
    /// 
    /// You can take an existing one to modify it.
    public static let emptySimulationPlaceholder = L10n.tr("Plome", "home.empty_simulation_placeholder", fallback: "You will find here all your exam simulations.\n\nYou can take an existing one to modify it.")
    /// Final grade
    public static let finalGrade = L10n.tr("Plome", "home.final_grade", fallback: "Final grade")
    /// Grade
    public static let grade = L10n.tr("Plome", "home.grade", fallback: "Grade")
    /// 08/20
    public static let gradePlaceholder = L10n.tr("Plome", "home.grade_placeholder", fallback: "08/20")
    /// How you catch up ?
    public static let howToCatchUp = L10n.tr("Plome", "home.how_to_catchUp", fallback: "How you catch up ?")
    /// How to complete the simulation?
    public static let howToCompleteSimulation = L10n.tr("Plome", "home.how_to_complete_simulation", fallback: "How to complete the simulation?")
    /// It's done !
    public static let itsDone = L10n.tr("Plome", "home.its_done", fallback: "It's done !")
    /// The model has been saved
    public static let modelHasBeenSave = L10n.tr("Plome", "home.model_has_been_save", fallback: "The model has been saved")
    /// My simulation
    public static let mySimulation = L10n.tr("Plome", "home.my_simulation", fallback: "My simulation")
    /// My simulations
    public static let mySimulations = L10n.tr("Plome", "home.my_simulations", fallback: "My simulations")
    /// New simulation
    public static let newSimulation = L10n.tr("Plome", "home.new_simulation", fallback: "New simulation")
    /// Remake a simulation
    public static let remakeSimulation = L10n.tr("Plome", "home.remake_simulation", fallback: "Remake a simulation")
    /// Re-simulate from this simulation
    public static let remakeSimulationFromThisOne = L10n.tr("Plome", "home.remake_simulation_from_this_one", fallback: "Re-simulate from this simulation")
    /// Result
    public static let result = L10n.tr("Plome", "home.result", fallback: "Result")
    /// Back to home
    public static let returnToHome = L10n.tr("Plome", "home.return_to_home", fallback: "Back to home")
    /// Save this model
    public static let saveModel = L10n.tr("Plome", "home.save_model", fallback: "Save this model")
    /// Select a model
    public static let selectAModel = L10n.tr("Plome", "home.select_a_model", fallback: "Select a model")
    /// Simulation from %@
    public static func simulationFromDate(_ p1: Any) -> String {
      return L10n.tr("Plome", "home.simulation_from_date", String(describing: p1), fallback: "Simulation from %@")
    }
    /// Here are a few rules for doing your simulation well.
    /// 
    /// 1. Decimal numbers are written with dots.
    /// 
    /// 2. Notes must be separated with a /.
    /// 
    /// 3. If you do not indicate a coefficient, it will be automatically set to 1 during the calculation.
    public static let simulationRules = L10n.tr("Plome", "home.simulation_rules", fallback: "Here are a few rules for doing your simulation well.\n\n1. Decimal numbers are written with dots.\n\n2. Notes must be separated with a /.\n\n3. If you do not indicate a coefficient, it will be automatically set to 1 during the calculation.")
    /// Some numbers
    public static let someNumbers = L10n.tr("Plome", "home.some_numbers", fallback: "Some numbers")
    /// Unadmit
    public static let unadmit = L10n.tr("Plome", "home.unadmit", fallback: "Unadmit")
    /// Worst grade
    public static let worstGrade = L10n.tr("Plome", "home.worst_grade", fallback: "Worst grade")
    /// You will graduate by earning extra points:
    public static let youWillObtainYourDiploma = L10n.tr("Plome", "home.you_will_obtain_your_diploma", fallback: "You will graduate by earning extra points:")
    /// Your score will then be
    public static let yourGradeWillBe = L10n.tr("Plome", "home.your_grade_will_be", fallback: "Your score will then be")
    /// Your grades
    public static let yourGrades = L10n.tr("Plome", "home.your_grades", fallback: "Your grades")
  }
  public enum Onboarding {
    /// Create your own exam templates in addition to what is already available.
    public static let modelText = L10n.tr("Plome", "onboarding.modelText", fallback: "Create your own exam templates in addition to what is already available.")
    /// Create your models
    public static let modelTitle = L10n.tr("Plome", "onboarding.modelTitle", fallback: "Create your models")
    /// Welcome to Plôme, the application that allows you to simulate your exams.
    public static let presentationText = L10n.tr("Plome", "onboarding.presentationText", fallback: "Welcome to Plôme, the application that allows you to simulate your exams.")
    /// Hello !
    public static let presentationTitle = L10n.tr("Plome", "onboarding.presentationTitle", fallback: "Hello !")
    /// Enter your scores and coefficients to get the result.
    public static let simulationText = L10n.tr("Plome", "onboarding.simulationText", fallback: "Enter your scores and coefficients to get the result.")
    /// Make simulations
    public static let simulationTitle = L10n.tr("Plome", "onboarding.simulationTitle", fallback: "Make simulations")
    /// You know everything !
    public static let startText = L10n.tr("Plome", "onboarding.startText", fallback: "You know everything !")
    /// Let's go !
    public static let startTitle = L10n.tr("Plome", "onboarding.startTitle", fallback: "Let's go !")
  }
  public enum Settings {
    /// Add the default models
    public static let addDefaultModel = L10n.tr("Plome", "settings.add_default_model", fallback: "Add the default models")
    /// All simulations have been deleted.
    public static let allSimulationHasBeenDeleted = L10n.tr("Plome", "settings.all_simulation_has_been_deleted", fallback: "All simulations have been deleted.")
    /// The application has been successfully reset.
    public static let appHasBeenReinitialized = L10n.tr("Plome", "settings.app_has_been_reinitialized", fallback: "The application has been successfully reset.")
    /// Plôme
    public static let appName = L10n.tr("Plome", "settings.app_name", fallback: "Plôme")
    /// mazuc.loic@icloud.com
    public static let assistanceMail = L10n.tr("Plome", "settings.assistance_mail", fallback: "mazuc.loic@icloud.com")
    /// Contact assistance
    public static let contactAssistance = L10n.tr("Plome", "settings.contact_assistance", fallback: "Contact assistance")
    /// The simulation models have been added.
    public static let defaultModelHasBeenAdded = L10n.tr("Plome", "settings.default_model_has_been_added", fallback: "The simulation models have been added.")
    /// You don't seem to have an email application.
    /// You can reach us at: mazuc.loic@icloud.com
    public static let errorLaunchMailApp = L10n.tr("Plome", "settings.error_launch_mail_app", fallback: "You don't seem to have an email application.\nYou can reach us at: mazuc.loic@icloud.com")
    /// 9.99
    public static let errorAppVersion = L10n.tr("Plome", "settings.errorAppVersion", fallback: "9.99")
    /// General
    public static let general = L10n.tr("Plome", "settings.general", fallback: "General")
    /// Other
    public static let other = L10n.tr("Plome", "settings.other", fallback: "Other")
    /// Reset app
    public static let reintializeApp = L10n.tr("Plome", "settings.reintialize_app", fallback: "Reset app")
    /// Remove all simulations
    public static let removeAllSimulations = L10n.tr("Plome", "settings.remove_all_simulations", fallback: "Remove all simulations")
    /// Settings
    public static let settings = L10n.tr("Plome", "settings.settings", fallback: "Settings")
    /// Version %@
    public static func version(_ p1: Any) -> String {
      return L10n.tr("Plome", "settings.version", String(describing: p1), fallback: "Version %@")
    }
    /// You are about to delete all app data, are you sure you want to continu?
    public static let warningMessageReinitialize = L10n.tr("Plome", "settings.warning_message_reinitialize", fallback: "You are about to delete all app data, are you sure you want to continu?")
    /// You are about to delete all simulations, are you sure you want to continu?
    public static let warningMessageRemoveSimulations = L10n.tr("Plome", "settings.warning_message_remove_simulations", fallback: "You are about to delete all simulations, are you sure you want to continu?")
  }
  public enum SimulationModels {
    /// Download a template
    public static let downloadModel = L10n.tr("Plome", "simulationModels.download_model", fallback: "Download a template")
    /// Here you will find all your exam simulation templates.
    /// 
    /// You can use an existing one to modify it.
    /// 
    /// You will also find default templates in the application settings.
    public static let emptyModelPlaceholder = L10n.tr("Plome", "simulationModels.empty_model_placeholder", fallback: "Here you will find all your exam simulation templates.\n\nYou can use an existing one to modify it.\n\nYou will also find default templates in the application settings.")
    /// New model
    public static let newModel = L10n.tr("Plome", "simulationModels.new_model", fallback: "New model")
    /// %d Continuous controls
    public static func numberOfContinousControls(_ p1: Int) -> String {
      return L10n.tr("Plome", "simulationModels.number_of_continous_controls", p1, fallback: "%d Continuous controls")
    }
    /// %d Options
    public static func numberOfOptions(_ p1: Int) -> String {
      return L10n.tr("Plome", "simulationModels.number_of_options", p1, fallback: "%d Options")
    }
    /// %d Trials
    public static func numberOfTrials(_ p1: Int) -> String {
      return L10n.tr("Plome", "simulationModels.number_of_trials", p1, fallback: "%d Trials")
    }
    /// Enter this code in the application settings to download the shared template. Warning, this code is only valid for 2 hours.
    public static let sharingCodeMessage = L10n.tr("Plome", "simulationModels.sharing_code_message", fallback: "Enter this code in the application settings to download the shared template. Warning, this code is only valid for 2 hours.")
    /// Bac Pro...
    public static let simulationModelPlaceholderName = L10n.tr("Plome", "simulationModels.simulation_model_placeholder_name", fallback: "Bac Pro...")
    /// The template has been added.
    public static let successDownloadMessage = L10n.tr("Plome", "simulationModels.success_download_message", fallback: "The template has been added.")
    /// That's good!
    public static let successDownloadTitle = L10n.tr("Plome", "simulationModels.success_download_title", fallback: "That's good!")
    /// You are about to delete this model. Are you sure you want to delete it?
    public static let warningMessageRemoveModel = L10n.tr("Plome", "simulationModels.warning_message_remove_model", fallback: "You are about to delete this model. Are you sure you want to delete it?")
    /// Enter the code that was shared with you.
    public static let writeCode = L10n.tr("Plome", "simulationModels.write_code", fallback: "Enter the code that was shared with you.")
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
