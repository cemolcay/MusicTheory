# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

workspace 'MusicTheory'

target 'MusicTheory' do
  use_frameworks!
  project 'MusicTheory.xcodeproj'
  pod 'AudioKit'
end

target 'AudioKitHelper' do
  use_frameworks!
  project 'AudioKitHelper/AudioKitHelper.xcodeproj'
  pod 'AudioKit'
end

target 'MacApp' do
  use_frameworks!
  project 'MacApp/MacApp.xcodeproj'
  pod 'AudioKit'
  pod 'MusicTheorySwift', :git => 'https://github.com/cemolcay/MusicTheory.git', :commit => '2cd1586ac9f8d1bbc3a1f9e3f97864d4d045f133'
  pod 'RainbowSwift'
end
