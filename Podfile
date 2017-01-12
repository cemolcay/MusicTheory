# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

workspace 'MusicTheory'

target 'MusicTheory' do
  use_frameworks!
  xcodeproj 'MusicTheory.xcodeproj'
  pod 'AudioKit'
end

target 'AudioKitHelper' do
  use_frameworks!
  xcodeproj 'AudioKitHelper/AudioKitHelper.xcodeproj'
  pod 'AudioKit'
end

target 'MacApp' do
  use_frameworks!
  xcodeproj 'MacApp/MacApp.xcodeproj'
  pod 'AudioKit'
  pod 'MusicTheorySwift'
  pod 'RainbowSwift'
end
