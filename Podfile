# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

use_frameworks!

workspace 'Plome.xcworkspace'

def project_path(projectName)
  return "./Plome/#{projectName}/#{projectName}"
end

target 'PlomeCoreKit' do
  project project_path("PlomeCoreKit")
  
end

target 'Plome' do
    pod 'MaterialComponents/TextControls+OutlinedTextFields'
    pod 'MaterialComponents/TextControls+OutlinedTextFieldsTheming'
    pod 'MDFInternationalization'
end
