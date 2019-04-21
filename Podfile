# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

target 'Aruba' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Aruba
  pod 'Alamofire'
  pod 'SwiftLint'
  pod 'SideMenu'
  pod 'MaterialTextField'
  pod 'SVProgressHUD'
  pod 'Firebase/Core'
  
  post_install do |installer|
      installer.pods_project.build_configurations.each do |config|
          # Do not need debug information for pods
          config.build_settings['DEBUG_INFORMATION_FORMAT'] = 'dwarf'
          
          # Disable Code Coverage for Pods projects - only exclude ObjC pods
          config.build_settings['CLANG_ENABLE_CODE_COVERAGE'] = 'NO'
          config.build_settings['LD_RUNPATH_SEARCH_PATHS'] = ['$(FRAMEWORK_SEARCH_PATHS)']
          
          config.build_settings['SWIFT_VERSION'] = '4.2'
      end
  end

  target 'ArubaTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'ArubaUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
