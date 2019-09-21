Pod::Spec.new do |s|
    s.name             = 'WolfNetwork'
    s.version          = '3.0.5'
    s.summary          = 'Tools for working with networking, particularly REST/JSON.'

    s.homepage         = 'https://github.com/wolfmcnally/WolfNetwork'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Wolf McNally' => 'wolf@wolfmcnally.com' }
    s.source           = { :git => 'https://github.com/wolfmcnally/WolfNetwork.git', :tag => s.version.to_s }

    s.swift_version = '5.0'

    s.ios.deployment_target = '12.0'
    s.ios.source_files = 'Sources/WolfNetwork/Shared/**/*', 'Sources/WolfNetwork/iOS/**/*', 'Sources/WolfNetwork/iOSShared/**/*', 'Sources/WolfNetwork/AppleShared/**/*'

    s.macos.deployment_target = '10.14'
    s.macos.source_files = 'Sources/WolfNetwork/Shared/**/*', 'Sources/WolfNetwork/macOS/**/*', 'Sources/WolfNetwork/AppleShared/**/*'

    s.tvos.deployment_target = '12.0'
    s.tvos.source_files = 'Sources/WolfNetwork/Shared/**/*', 'Sources/WolfNetwork/tvOS/**/*', 'Sources/WolfNetwork/iOSShared/**/*', 'Sources/WolfNetwork/AppleShared/**/*'

    s.module_name = 'WolfNetwork'

    s.dependency 'WolfCore'
    s.dependency 'WolfLog'
    s.dependency 'WolfLocale'
    s.dependency 'WolfSec'
    s.dependency 'WolfApp'
    s.dependency 'WolfPubSub'
    s.dependency 'WolfNIO'
end
