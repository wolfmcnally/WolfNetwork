Pod::Spec.new do |s|
    s.name             = 'WolfNetwork'
    s.version          = '3.0.1'
    s.summary          = 'Tools for working with networking, particularly REST/JSON.'

    s.homepage         = 'https://github.com/wolfmcnally/WolfNetwork'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Wolf McNally' => 'wolf@wolfmcnally.com' }
    s.source           = { :git => 'https://github.com/wolfmcnally/WolfNetwork.git', :tag => s.version.to_s }

    s.swift_version = '5.0'

    s.ios.deployment_target = '12.0'
    s.ios.source_files = 'WolfNetwork/Classes/Shared/**/*', 'WolfNetwork/Classes/iOS/**/*', 'WolfNetwork/Classes/iOSShared/**/*', 'WolfNetwork/Classes/AppleShared/**/*'

    s.macos.deployment_target = '10.14'
    s.macos.source_files = 'WolfNetwork/Classes/Shared/**/*', 'WolfNetwork/Classes/macOS/**/*', 'WolfNetwork/Classes/AppleShared/**/*'

    s.tvos.deployment_target = '12.0'
    s.tvos.source_files = 'WolfNetwork/Classes/Shared/**/*', 'WolfNetwork/Classes/tvOS/**/*', 'WolfNetwork/Classes/iOSShared/**/*', 'WolfNetwork/Classes/AppleShared/**/*'

    s.module_name = 'WolfNetwork'

    s.dependency 'WolfPipe'
    s.dependency 'WolfLog'
    s.dependency 'WolfLocale'
    s.dependency 'ExtensibleEnumeratedName'
    s.dependency 'WolfConcurrency'
    s.dependency 'WolfSec'
    s.dependency 'WolfApp'
    s.dependency 'WolfPubSub'
    s.dependency 'WolfFoundation'
    s.dependency 'WolfNIO'
end
