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
  pod 'MusicTheorySwift', :git => 'https://github.com/cemolcay/MusicTheory.git', :commit => '5f0fe8876c87a2b5726f1b73dd4fe61bcc3a0cfa'
  pod 'RainbowSwift'
end
