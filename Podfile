# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'roomshare' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

def common_pods
    pod 'Firebase/Core'
    pod 'Firebase/Messaging'
    pod 'Firebase/Auth'
    pod 'FirebaseUI'
end

  # Pods for roomshare
  common_pods

  target 'roomshareTests' do
    inherit! :search_paths
    # Pods for testing
    common_pods
  end

  target 'roomshareUITests' do
    inherit! :search_paths
    common_pods
  end

end
