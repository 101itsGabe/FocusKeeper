source 'https://github.com/CocoaPods/Specs.git'

platform :macos, '14.0'

target 'FocusKeeper' do
  use_frameworks!

  # Pods for FocusKeeper
  pod 'Apptics-SDK'

  # Pre build script will register the app version, upload dSYM file to the server and add Apptics specific information to the main info.plist which will be used by the SDK.
  script_phase :name => 'Apptics pre build', :script => 'sh "./Pods/Apptics-SDK/scripts/run" --upload-symbols-for-configurations="Release, Appstore"', :execution_position => :before_compile
end
